// utils/otp.ts
export function generateOTP(length: number = 6): string {
  let otp = "";
  const digits = "0123456789";
  for (let i = 0; i < length; i++) {
    otp += digits[Math.floor(Math.random() * 10)];
  }
  return otp;
}

export const secret = new TextEncoder().encode(process.env.JWT_REGISTRATION_SECRET!);