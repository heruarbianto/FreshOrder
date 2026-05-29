-- CreateTable
CREATE TABLE `User` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `nama` VARCHAR(191) NOT NULL,
    `no_hp` VARCHAR(191) NOT NULL,
    `email` VARCHAR(191) NULL,
    `password` VARCHAR(191) NOT NULL,
    `role` ENUM('CUSTOMER', 'ADMIN', 'KURIR') NOT NULL,
    `foto_profil` VARCHAR(191) NULL,
    `aktif` BOOLEAN NOT NULL DEFAULT true,
    `terakhir_login` DATETIME(3) NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `diupdate_pada` DATETIME(3) NOT NULL,

    UNIQUE INDEX `User_no_hp_key`(`no_hp`),
    UNIQUE INDEX `User_email_key`(`email`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Alamat` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `label` VARCHAR(191) NOT NULL,
    `nama_penerima` VARCHAR(191) NOT NULL,
    `no_hp_penerima` VARCHAR(191) NOT NULL,
    `provinsi` VARCHAR(191) NOT NULL,
    `kota` VARCHAR(191) NOT NULL,
    `kecamatan` VARCHAR(191) NOT NULL,
    `kelurahan` VARCHAR(191) NOT NULL,
    `kode_pos` VARCHAR(191) NOT NULL,
    `detail_alamat` VARCHAR(191) NOT NULL,
    `catatan` VARCHAR(191) NULL,
    `latitude` DOUBLE NOT NULL,
    `longitude` DOUBLE NOT NULL,
    `default_alamat` BOOLEAN NOT NULL DEFAULT false,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `diupdate_pada` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Kategori` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `nama` VARCHAR(191) NOT NULL,
    `icon` VARCHAR(191) NULL,
    `aktif` BOOLEAN NOT NULL DEFAULT true,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Produk` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `kategori_id` BIGINT NOT NULL,
    `nama` VARCHAR(191) NOT NULL,
    `slug` VARCHAR(191) NOT NULL,
    `tipe_pembelian` ENUM('FIXED', 'NOMINAL') NOT NULL,
    `satuan` VARCHAR(191) NULL,
    `harga_default` INTEGER NULL,
    `gambar` VARCHAR(191) NULL,
    `deskripsi` VARCHAR(191) NULL,
    `tersedia` BOOLEAN NOT NULL DEFAULT true,
    `aktif` BOOLEAN NOT NULL DEFAULT true,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `diupdate_pada` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Produk_slug_key`(`slug`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `HargaProduk` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `produk_id` BIGINT NOT NULL,
    `harga_modal` INTEGER NOT NULL,
    `harga_jual` INTEGER NOT NULL,
    `tanggal_berlaku` DATETIME(3) NOT NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `StokProduk` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `produk_id` BIGINT NOT NULL,
    `jumlah_stok` DOUBLE NOT NULL DEFAULT 0,
    `stok_reserved` DOUBLE NOT NULL DEFAULT 0,
    `satuan_stok` VARCHAR(191) NOT NULL,
    `diupdate_pada` DATETIME(3) NOT NULL,

    UNIQUE INDEX `StokProduk_produk_id_key`(`produk_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `StokMutasi` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `produk_id` BIGINT NOT NULL,
    `tipe_mutasi` ENUM('MASUK', 'KELUAR', 'RESERVED', 'RELEASE', 'KOREKSI', 'RETUR') NOT NULL,
    `jumlah` DOUBLE NOT NULL,
    `keterangan` VARCHAR(191) NOT NULL,
    `referensi_id` BIGINT NULL,
    `referensi_tipe` VARCHAR(191) NULL,
    `user_id` BIGINT NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Keranjang` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `diupdate_pada` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `ItemKeranjang` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `keranjang_id` BIGINT NOT NULL,
    `produk_id` BIGINT NOT NULL,
    `tipe_pembelian` ENUM('FIXED', 'NOMINAL') NOT NULL,
    `qty` DOUBLE NULL,
    `harga_satuan` INTEGER NULL,
    `nominal` INTEGER NULL,
    `qty_nominal` INTEGER NULL,
    `subtotal` INTEGER NOT NULL,
    `catatan` VARCHAR(191) NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `SlotPengiriman` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `nama` VARCHAR(191) NOT NULL,
    `hari` INTEGER NOT NULL,
    `jam_mulai` VARCHAR(191) NOT NULL,
    `jam_selesai` VARCHAR(191) NOT NULL,
    `maksimal_pesanan` INTEGER NOT NULL,
    `aktif` BOOLEAN NOT NULL DEFAULT true,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `PengaturanOngkir` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `nama` VARCHAR(191) NOT NULL,
    `jarak_minimal_km` DOUBLE NOT NULL,
    `ongkir_minimal` INTEGER NOT NULL,
    `biaya_per_km` INTEGER NOT NULL,
    `radius_maksimal_km` DOUBLE NOT NULL,
    `aktif` BOOLEAN NOT NULL DEFAULT true,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `diupdate_pada` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `PengaturanToko` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `nama_toko` VARCHAR(191) NOT NULL,
    `nomor_whatsapp` VARCHAR(191) NOT NULL,
    `latitude_toko` DOUBLE NOT NULL,
    `longitude_toko` DOUBLE NOT NULL,
    `radius_pengiriman_km` DOUBLE NOT NULL,
    `minimum_order` INTEGER NOT NULL,
    `biaya_layanan` INTEGER NOT NULL,
    `jam_buka` VARCHAR(191) NOT NULL,
    `jam_tutup` VARCHAR(191) NOT NULL,
    `status_toko` BOOLEAN NOT NULL DEFAULT true,
    `tutup_sementara` BOOLEAN NOT NULL DEFAULT false,
    `alasan_tutup` VARCHAR(191) NULL,
    `tanggal_tutup_mulai` DATETIME(3) NULL,
    `tanggal_tutup_sampai` DATETIME(3) NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `diupdate_pada` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Pesanan` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `nomor_invoice` VARCHAR(191) NOT NULL,
    `user_id` BIGINT NOT NULL,
    `alamat_id` BIGINT NOT NULL,
    `kurir_id` BIGINT NULL,
    `metode_pembayaran` ENUM('COD', 'PAYMENT_GATEWAY') NOT NULL,
    `status_pembayaran` ENUM('UNPAID', 'PENDING', 'PAID', 'FAILED', 'EXPIRED', 'REFUNDED', 'CANCELED') NOT NULL,
    `status_pesanan` ENUM('PENDING', 'DIKONFIRMASI', 'DIBELANJAKAN', 'DIKEMAS', 'DIANTAR', 'SELESAI', 'DIBATALKAN') NOT NULL,
    `tipe_jadwal` ENUM('SLOT_JADWAL', 'KAPAN_SAJA', 'CUSTOM') NOT NULL,
    `slot_pengiriman_id` BIGINT NULL,
    `tanggal_custom` DATETIME(3) NULL,
    `jarak_km` DOUBLE NULL,
    `biaya_pengiriman` INTEGER NOT NULL,
    `subtotal` INTEGER NOT NULL,
    `biaya_layanan` INTEGER NOT NULL,
    `biaya_aplikasi` INTEGER NOT NULL,
    `diskon` INTEGER NOT NULL,
    `total_akhir` INTEGER NOT NULL,
    `catatan_customer` VARCHAR(191) NULL,
    `catatan_admin` VARCHAR(191) NULL,
    `dipesan_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `dikonfirmasi_pada` DATETIME(3) NULL,
    `dibelanjakan_pada` DATETIME(3) NULL,
    `dikemas_pada` DATETIME(3) NULL,
    `dikirim_pada` DATETIME(3) NULL,
    `selesai_pada` DATETIME(3) NULL,
    `dibatalkan_pada` DATETIME(3) NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `diupdate_pada` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Pesanan_nomor_invoice_key`(`nomor_invoice`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `ItemPesanan` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `pesanan_id` BIGINT NOT NULL,
    `produk_id` BIGINT NOT NULL,
    `nama_produk_snapshot` VARCHAR(191) NOT NULL,
    `tipe_pembelian` ENUM('FIXED', 'NOMINAL') NOT NULL,
    `qty` DOUBLE NULL,
    `harga_satuan` INTEGER NULL,
    `nominal` INTEGER NULL,
    `qty_nominal` INTEGER NULL,
    `harga_modal` INTEGER NOT NULL,
    `harga_jual` INTEGER NOT NULL,
    `subtotal` INTEGER NOT NULL,
    `catatan` VARCHAR(191) NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `MetodePembayaranTersedia` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `kode` VARCHAR(191) NOT NULL,
    `nama` VARCHAR(191) NOT NULL,
    `provider` VARCHAR(191) NULL,
    `biaya_admin` INTEGER NOT NULL DEFAULT 0,
    `aktif` BOOLEAN NOT NULL DEFAULT true,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `MetodePembayaranTersedia_kode_key`(`kode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Pembayaran` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `pesanan_id` BIGINT NOT NULL,
    `metode_pembayaran_id` BIGINT NOT NULL,
    `provider` ENUM('MIDTRANS', 'XENDIT', 'TRIPAY', 'MANUAL', 'COD') NOT NULL,
    `channel_pembayaran` VARCHAR(191) NULL,
    `kode_pembayaran` VARCHAR(191) NULL,
    `external_id` VARCHAR(191) NULL,
    `total_kotor` INTEGER NOT NULL,
    `biaya_admin` INTEGER NOT NULL,
    `total_bersih` INTEGER NOT NULL,
    `url_pembayaran` VARCHAR(191) NULL,
    `qr_string` VARCHAR(191) NULL,
    `expired_pada` DATETIME(3) NULL,
    `dibayar_pada` DATETIME(3) NULL,
    `status_pembayaran` ENUM('UNPAID', 'PENDING', 'PAID', 'FAILED', 'EXPIRED', 'REFUNDED', 'CANCELED') NOT NULL,
    `response_gateway` JSON NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `diupdate_pada` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `CallbackPembayaran` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `pembayaran_id` BIGINT NOT NULL,
    `provider` VARCHAR(191) NOT NULL,
    `tipe_callback` VARCHAR(191) NOT NULL,
    `payload` JSON NOT NULL,
    `signature_key` VARCHAR(191) NULL,
    `valid` BOOLEAN NOT NULL,
    `diterima_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `RefundPembayaran` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `pembayaran_id` BIGINT NOT NULL,
    `jumlah_refund` INTEGER NOT NULL,
    `alasan` VARCHAR(191) NOT NULL,
    `status_refund` VARCHAR(191) NOT NULL,
    `direfund_pada` DATETIME(3) NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `LogPembayaran` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `pembayaran_id` BIGINT NOT NULL,
    `status_sebelum` VARCHAR(191) NOT NULL,
    `status_sesudah` VARCHAR(191) NOT NULL,
    `catatan` VARCHAR(191) NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `VerifikasiCOD` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `pesanan_id` BIGINT NOT NULL,
    `url_video_selfie` VARCHAR(191) NULL,
    `foto_rumah` VARCHAR(191) NULL,
    `latitude` DOUBLE NOT NULL,
    `longitude` DOUBLE NOT NULL,
    `akurasi_gps` DOUBLE NULL,
    `info_device` VARCHAR(191) NULL,
    `ip_address` VARCHAR(191) NULL,
    `diverifikasi_pada` DATETIME(3) NOT NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Pengiriman` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `pesanan_id` BIGINT NOT NULL,
    `kurir_id` BIGINT NOT NULL,
    `status_pengiriman` ENUM('MENUNGGU', 'DIANTAR', 'SAMPAI', 'SELESAI', 'GAGAL') NOT NULL,
    `mulai_pada` DATETIME(3) NULL,
    `sampai_pada` DATETIME(3) NULL,
    `foto_bukti` VARCHAR(191) NULL,
    `catatan` VARCHAR(191) NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `LogStatusPesanan` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `pesanan_id` BIGINT NOT NULL,
    `user_id` BIGINT NOT NULL,
    `status` VARCHAR(191) NOT NULL,
    `catatan` VARCHAR(191) NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Voucher` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `kode` VARCHAR(191) NOT NULL,
    `jenis` ENUM('PERSEN', 'NOMINAL') NOT NULL,
    `nilai` INTEGER NOT NULL,
    `minimum_belanja` INTEGER NULL,
    `maksimal_diskon` INTEGER NULL,
    `batas_penggunaan` INTEGER NULL,
    `total_digunakan` INTEGER NOT NULL DEFAULT 0,
    `expired_pada` DATETIME(3) NULL,
    `aktif` BOOLEAN NOT NULL DEFAULT true,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `Voucher_kode_key`(`kode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `VoucherPesanan` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `pesanan_id` BIGINT NOT NULL,
    `voucher_id` BIGINT NOT NULL,
    `jumlah_diskon` INTEGER NOT NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Notifikasi` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `judul` VARCHAR(191) NOT NULL,
    `isi` VARCHAR(191) NOT NULL,
    `dibaca` BOOLEAN NOT NULL DEFAULT false,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Pengeluaran` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `judul` VARCHAR(191) NOT NULL,
    `kategori` VARCHAR(191) NOT NULL,
    `jumlah` INTEGER NOT NULL,
    `catatan` VARCHAR(191) NULL,
    `tanggal_pengeluaran` DATETIME(3) NOT NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `LaporanPendapatan` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `tanggal_laporan` DATETIME(3) NOT NULL,
    `total_pesanan` INTEGER NOT NULL,
    `total_pendapatan` INTEGER NOT NULL,
    `total_modal` INTEGER NOT NULL,
    `total_keuntungan` INTEGER NOT NULL,
    `total_ongkir` INTEGER NOT NULL,
    `total_biaya_layanan` INTEGER NOT NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `LaporanLabaRugi` (
    `id` BIGINT NOT NULL AUTO_INCREMENT,
    `tanggal_laporan` DATETIME(3) NOT NULL,
    `total_pemasukan` INTEGER NOT NULL,
    `total_pengeluaran` INTEGER NOT NULL,
    `laba_bersih` INTEGER NOT NULL,
    `dibuat_pada` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Alamat` ADD CONSTRAINT `Alamat_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `User`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Produk` ADD CONSTRAINT `Produk_kategori_id_fkey` FOREIGN KEY (`kategori_id`) REFERENCES `Kategori`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `HargaProduk` ADD CONSTRAINT `HargaProduk_produk_id_fkey` FOREIGN KEY (`produk_id`) REFERENCES `Produk`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `StokProduk` ADD CONSTRAINT `StokProduk_produk_id_fkey` FOREIGN KEY (`produk_id`) REFERENCES `Produk`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `StokMutasi` ADD CONSTRAINT `StokMutasi_produk_id_fkey` FOREIGN KEY (`produk_id`) REFERENCES `Produk`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `StokMutasi` ADD CONSTRAINT `StokMutasi_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Keranjang` ADD CONSTRAINT `Keranjang_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `User`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `ItemKeranjang` ADD CONSTRAINT `ItemKeranjang_keranjang_id_fkey` FOREIGN KEY (`keranjang_id`) REFERENCES `Keranjang`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `ItemKeranjang` ADD CONSTRAINT `ItemKeranjang_produk_id_fkey` FOREIGN KEY (`produk_id`) REFERENCES `Produk`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Pesanan` ADD CONSTRAINT `Pesanan_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Pesanan` ADD CONSTRAINT `Pesanan_alamat_id_fkey` FOREIGN KEY (`alamat_id`) REFERENCES `Alamat`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Pesanan` ADD CONSTRAINT `Pesanan_kurir_id_fkey` FOREIGN KEY (`kurir_id`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Pesanan` ADD CONSTRAINT `Pesanan_slot_pengiriman_id_fkey` FOREIGN KEY (`slot_pengiriman_id`) REFERENCES `SlotPengiriman`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `ItemPesanan` ADD CONSTRAINT `ItemPesanan_pesanan_id_fkey` FOREIGN KEY (`pesanan_id`) REFERENCES `Pesanan`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `ItemPesanan` ADD CONSTRAINT `ItemPesanan_produk_id_fkey` FOREIGN KEY (`produk_id`) REFERENCES `Produk`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Pembayaran` ADD CONSTRAINT `Pembayaran_pesanan_id_fkey` FOREIGN KEY (`pesanan_id`) REFERENCES `Pesanan`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Pembayaran` ADD CONSTRAINT `Pembayaran_metode_pembayaran_id_fkey` FOREIGN KEY (`metode_pembayaran_id`) REFERENCES `MetodePembayaranTersedia`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CallbackPembayaran` ADD CONSTRAINT `CallbackPembayaran_pembayaran_id_fkey` FOREIGN KEY (`pembayaran_id`) REFERENCES `Pembayaran`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RefundPembayaran` ADD CONSTRAINT `RefundPembayaran_pembayaran_id_fkey` FOREIGN KEY (`pembayaran_id`) REFERENCES `Pembayaran`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `LogPembayaran` ADD CONSTRAINT `LogPembayaran_pembayaran_id_fkey` FOREIGN KEY (`pembayaran_id`) REFERENCES `Pembayaran`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `VerifikasiCOD` ADD CONSTRAINT `VerifikasiCOD_pesanan_id_fkey` FOREIGN KEY (`pesanan_id`) REFERENCES `Pesanan`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Pengiriman` ADD CONSTRAINT `Pengiriman_pesanan_id_fkey` FOREIGN KEY (`pesanan_id`) REFERENCES `Pesanan`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Pengiriman` ADD CONSTRAINT `Pengiriman_kurir_id_fkey` FOREIGN KEY (`kurir_id`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `LogStatusPesanan` ADD CONSTRAINT `LogStatusPesanan_pesanan_id_fkey` FOREIGN KEY (`pesanan_id`) REFERENCES `Pesanan`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `LogStatusPesanan` ADD CONSTRAINT `LogStatusPesanan_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `VoucherPesanan` ADD CONSTRAINT `VoucherPesanan_pesanan_id_fkey` FOREIGN KEY (`pesanan_id`) REFERENCES `Pesanan`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `VoucherPesanan` ADD CONSTRAINT `VoucherPesanan_voucher_id_fkey` FOREIGN KEY (`voucher_id`) REFERENCES `Voucher`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Notifikasi` ADD CONSTRAINT `Notifikasi_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `User`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Pengeluaran` ADD CONSTRAINT `Pengeluaran_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
