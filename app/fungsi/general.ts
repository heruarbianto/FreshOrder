import { NextResponse } from "next/server";
// src/index.ts
import path from "path";
import fs  from "fs";
import { genSaltSync, hashSync, } from "bcrypt-ts";
import { PrismaMariaDb } from "@prisma/adapter-mariadb";
import { PrismaClient } from "../generated/prisma/client";
const adapter = new PrismaMariaDb({
  host: process.env.DATABASE_HOST,
  user: process.env.DATABASE_USER,
  password: process.env.DATABASE_PASSWORD,
  database: process.env.DATABASE_NAME,
  connectionLimit: 5,
});
export const prisma = new PrismaClient({ adapter });

 //  Buat rspon untuk "Data Tidak Ditemukan"
export const getResponseNotFound =()=>{

  return NextResponse.json(
     {
       metadata: {
         error: 1,
         message: "Data Tidak Ditemukan",
       },
     },{
       status:404
     })
     
   }

  //  FUngsi menyimpan file upload
   export const saveFile = async (base64Data: string, fileName: string): Promise<string> => {
    const uploadDir = path.join(process.cwd(), 'public/imageMenu'); // Direktori penyimpanan file
    // Pastikan folder target ada atau buat jika belum ada
    if (!fs.existsSync(uploadDir)) {
      fs.mkdirSync(uploadDir, { recursive: true });
    }
    const filePath = path.join(uploadDir, fileName);
    const buffer = Buffer.from(base64Data, 'base64')
    // Ubah Buffer ke Uint8Array agar kompatibel
    const uint8ArrayBuffer = new Uint8Array(buffer);
  
    // Simpan file dengan fs
    await fs.promises.writeFile(filePath, uint8ArrayBuffer);
    // Simpan file ke direktori
  
    return `/imageMenu/${fileName}`; // Return path relatif untuk database
  };



  export const setBcrypt =(password:string)=>{
    const salt = genSaltSync(10);
    return hashSync(password, salt)
}