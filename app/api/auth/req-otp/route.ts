import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { generateOTP, secret } from "@/app/fungsi/auth";
import { prisma } from "@/app/fungsi/general";
import { SignJWT } from "jose";
// Schema Validasi dengan Zod
const requestOTPSchema = z.object({
  email: z
    .string()
    .min(1, "Email wajib diisi")
    .email("Format email tidak valid")
    .max(255, "Email terlalu panjang")
    .trim()
    .toLowerCase(),

  purpose: z
    .enum(["REGISTER", "LOGIN", "FORGOT_PASSWORD", "CHANGE_EMAIL"])
    .default("REGISTER"),
});

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();

    // === Validasi Input ===
    const validation = requestOTPSchema.safeParse(body);

    if (!validation.success) {
      return NextResponse.json(
        {
          success: false,
          message: "Validasi gagal",
          errors: validation.error.flatten().fieldErrors,
        },
        { status: 400 }
      );
    }

    const { email, purpose } = validation.data;

    // === Tambahan Security Check ===
    if (email.length > 320) {
      return NextResponse.json(
        { success: false, message: "Email tidak valid" },
        { status: 400 }
      );
    }

    // Cegah email disposable / suspicious (opsional, bisa ditambah list)
    const suspiciousDomains = ["tempmail", "guerrillamail", "10minutemail"];
    const domain = email.split("@")[1];
    if (suspiciousDomains.some((d) => domain.includes(d))) {
      return NextResponse.json(
        { success: false, message: "Email tidak didukung" },
        { status: 400 }
      );
    }

    // 1. Cek apakah email sudah terdaftar
    const existingUser = await prisma.user.findUnique({
      where: { email },
    });

    // Logika bisnis berdasarkan purpose
    if (purpose === "REGISTER" && existingUser) {
      return NextResponse.json(
        { success: false, message: "Email sudah terdaftar" },
        { status: 409 }
      );
    }

    if (
      (purpose === "LOGIN" ||
        purpose === "FORGOT_PASSWORD" ||
        purpose === "CHANGE_EMAIL") &&
      !existingUser
    ) {
      return NextResponse.json(
        { success: false, message: "Email tidak ditemukan" },
        { status: 404 }
      );
    }

    // 2. Hapus OTP lama untuk kombinasi email + purpose
    await prisma.emailOtp.deleteMany({
      where: { email, purpose },
    });

    // 3. Generate & Simpan OTP
    const otp = generateOTP(6);
    const expiresInMinutes = 10;
    const expiredAt = new Date(Date.now() + expiresInMinutes * 60 * 1000);

    await prisma.emailOtp.create({
      data: {
        email,
        otp,
        purpose,
        expiredAt,
      },
    });

    // 4. Kirim Email (dikomentar dulu)
    // await sendOTPEmail({ email, otp, purpose, expiresInMinutes });

    // Log untuk development
    console.log(
      `[OTP Requested] Email: ${email} | Purpose: ${purpose} | OTP: ${otp}`
    );
    const registerToken = await new SignJWT({
      email: "user@gmail.com",
      type: "register",
    })
      .setProtectedHeader({ alg: "HS256" }) // ✅ ini yang benar
      .setIssuedAt()
      .setExpirationTime("10m") // ⏱️ penting buat OTP
      .sign(secret);

    return NextResponse.json({
      success: true,
      message: "OTP berhasil dikirim ke email Anda",
      data: {
        registerToken, // Token ini bisa digunakan untuk validasi di endpoint verifikasi OTP
      },
    });
  } catch (error: any) {
    console.error("Request OTP Error:", error);

    // Hindari leak error detail ke user di production
    return NextResponse.json(
      {
        success: false,
        message: "Terjadi kesalahan internal. Silakan coba lagi.",
      },
      { status: 500 }
    );
  }
}
