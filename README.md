# SUKI V.0.01 - Program Kasir yang Terintegrasi

SUKI (System Integrated Kasir Integrated) adalah sebuah Program kasir yang  terintegrasi dengan sekumpulan program lainnya dibuat dengan tampilan yang berbasis text. Program ini bisa melakukan beberapa fungsi seperti melihat barang, belanja, menghitung diskon, pembayaran, mencetak struk, dan riwayat penjualan.


# Anggota Kelompok:
1. Alfriz Leonard Solvinus Tambunan (261401035), Kom-C, DP-5
2. Langga Ramadhan (261401021), Kom-C, DP-5
3. Wildan Abiyu Mazda (261401063), Kom-C, DP-5


## Fitur Utama

| Menu | Fitur | Keterangan |
|---|---|---|
| 1 | Lihat Daftar Barang | Menampilkan kode, nama, dan harga semua barang |
| 2 | Transaksi Baru | Input belanja, hitung diskon, pilih metode bayar, cetak struk |
| 3 | Laporan Penjualan | Jumlah transaksi, total pendapatan, rata-rata per transaksi |
| 4 | Keluar | Mengakhiri program |

## Daftar Barang

| Kode | Nama | Harga |
|---|---|---|
| 101 | Beras 5 kg | Rp65.000 |
| 102 | Minyak Goreng 2L | Rp38.000 |
| 103 | Gula Pasir 1 kg | Rp16.000 |
| 104 | Telur 1 kg | Rp28.000 |
| 105 | Mie Instan | Rp3.500 |
| 106 | Kopi Sachet | Rp2.000 |

## Alur Transaksi

1. Masukkan **kode barang** dan **jumlah**. Ulangi sampai mengetik kode `0`.
2. Program menghitung **subtotal**. Jika keranjang kosong, transaksi dibatalkan.
3. Program menentukan **diskon** berdasarkan subtotal, lalu menanyakan status **member**.
4. Pilih **metode pembayaran**, dan biaya admin ditambahkan ke total.
5. Untuk pembayaran tunai, masukkan uang diterima. Program menghitung kembalian.
6. **Struk** dicetak, lalu data masuk ke rekap penjualan.

## Aturan Diskon

**Diskon yang diberikan berdasarkan subtotal:**

| Subtotal | Diskon |
|---|---|
| >= Rp500.000 | 15% |
| >= Rp250.000 | 10% |
| >= Rp100.000 | 5% |
| di bawah Rp100.000 | 0% |

**Diskon member:**
- Jika sudah mendapat diskon bertingkat, ditambah **2%**.
- Jika belum mendapat diskon, member mendapat **2%** bila belanja >= Rp50.000.

## Metode Pembayaran

| Metode | Biaya Admin |
|---|---|
| Tunai | Rp0 (input uang diulang sampai cukup) |
| Kartu Debit | Rp1.000 |
| E-Wallet | 0,5% dari total |

## Rumus Perhitungan

```
diskon  = subtotal * persen div 100
total   = subtotal - diskon + biaya admin
kembali = bayar - total
```

## Logika dan Struktur Program

- **Struktur data**: `record TBarang` (kode, nama, harga) disimpan dalam `array[1..6]` supaya tidak kompleks. Array `qty` mencatat jumlah beli tiap barang.
- **Menu utama**: loop `repeat-until pilihan = 4` dengan percabangan `if-else if`.
- **Input belanja**: loop `repeat` dengan `break` (kode 0 = selesai) dan `continue` (kode tidak ditemukan atau jumlah <= 0 = ulangi input).
- **Pencarian barang**: mencari barang dengan menggunakan `for` pada array.
- **Validasi metode bayar**: `repeat-until` sampai input bernilai 1-3.
- **Struk**: dicetak dengan `for`, hanya untuk barang dengan `qty > 0`.
- **Riwayat Penjualan**: `totalPenjualan` dan `jumlahTransaksi` tersimpan setiap transaksi berhasil.
