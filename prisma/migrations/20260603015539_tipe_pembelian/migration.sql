-- AlterTable
ALTER TABLE `ItemKeranjang` MODIFY `tipe_pembelian` ENUM('FIXED', 'NOMINAL', 'WEIGHT') NOT NULL;

-- AlterTable
ALTER TABLE `ItemPesanan` MODIFY `tipe_pembelian` ENUM('FIXED', 'NOMINAL', 'WEIGHT') NOT NULL;

-- AlterTable
ALTER TABLE `Produk` MODIFY `tipe_pembelian` ENUM('FIXED', 'NOMINAL', 'WEIGHT') NOT NULL;
