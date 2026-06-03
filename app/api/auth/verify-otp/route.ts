import { secret } from "@/app/fungsi/auth";
import { prisma } from "@/app/fungsi/general";
import { compareSync } from "bcrypt-ts";
import { SignJWT } from "jose";
import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";

// Schema Validasi
const verifyOTPSchema = z.object({
  email: z
    .string()
    .min(1, "Email wajib diisi")
    .email("Format email tidak valid")
    .max(255)
    .trim()
    .toLowerCase(),

  otp: z
    .string()
    .length(6, "OTP harus 6 digit")
    .regex(/^\d{6}$/, "OTP hanya boleh berisi angka"),

  purpose: z.enum(["REGISTER", "LOGIN", "FORGOT_PASSWORD", "CHANGE_EMAIL"]),
});

export async function POST(req: NextRequest) {
  try {
    const body = await req.json();

    // Validasi input
    const validation = verifyOTPSchema.safeParse(body);
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

    const { email, otp, purpose } = validation.data;

    // Cari OTP yang aktif
    const emailOtp = await prisma.emailOtp.findFirst({
      where: {
        email,
        purpose,
        expiredAt: { gt: new Date() }, // belum expired
        verifiedAt: null, // belum diverifikasi
      },
    });

    if (!emailOtp) {
      return NextResponse.json(
        {
          success: false,
          message: "OTP tidak valid atau sudah expired",
        },
        { status: 400 }
      );
    }

    // Cek max attempts (misalnya maksimal 5 kali salah)
    const MAX_ATTEMPTS = 5;
    if (emailOtp.attempts >= MAX_ATTEMPTS) {
      // Hapus OTP jika sudah terlalu banyak percobaan
      await prisma.emailOtp.delete({ where: { id: emailOtp.id } });
      return NextResponse.json(
        {
          success: false,
          message: "Terlalu banyak percobaan. Silakan request OTP baru.",
        },
        { status: 429 }
      );
    }

    // Verifikasi OTP
    const isOtpValid = await compareSync(otp, emailOtp.otp);
    if (!isOtpValid) {
      // Increment attempts jika salah
      await prisma.emailOtp.update({
        where: { id: emailOtp.id },
        data: {
          attempts: {
            increment: 1,
          },
        },
      });

      return NextResponse.json(
        {
          success: false,
          message: `OTP salah. Sisa percobaan: ${
            MAX_ATTEMPTS - emailOtp.attempts - 1
          }`,
          remainingAttempts: MAX_ATTEMPTS - emailOtp.attempts - 1,
        },
        { status: 400 }
      );
    }

    // === OTP BENAR ===
    // Update status verified
    await prisma.emailOtp.delete({
      where: {
        id: emailOtp.id,
      },
    });

    let responseData: any = {
      email,
      purpose,
      verified: true,
    };

    // Logika tambahan berdasarkan purpose
    if (purpose === "LOGIN" || purpose === "REGISTER") {
      // Bisa tambahkan logic generate JWT / session di sini nanti
      responseData.message = "OTP berhasil diverifikasi";
    } else if (purpose === "FORGOT_PASSWORD") {
      responseData.message = "OTP valid. Silakan buat password baru.";
      responseData.resetToken = emailOtp.id; // bisa digunakan sebagai reset token sementara
    } else if (purpose === "CHANGE_EMAIL") {
      responseData.message = "Email berhasil diverifikasi.";
    }

    const verifToken = await new SignJWT({
      email,
      type: purpose,
    })
      .setProtectedHeader({ alg: "HS256" }) // ✅ ini yang benar
      .setIssuedAt()
      .setExpirationTime("10m") // ⏱️ penting buat OTP
      .sign(secret);
    return NextResponse.json({
      success: true,
      message: "OTP berhasil diverifikasi",
      data: {
        verified: true,
        purpose,
        verifToken,
      },
    });
  } catch (error: any) {
    console.error("Verify OTP Error:", error);
    return NextResponse.json(
      {
        success: false,
        message: "Terjadi kesalahan internal",
      },
      { status: 500 }
    );
  }
}
