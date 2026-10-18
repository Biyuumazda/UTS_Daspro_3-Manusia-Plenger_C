program System_Unit_Kasir_Integrated;
uses crt;

const
  MAX_BARANG = 6;


{menggunakan Record untuk menyimplekan nyimpan nilai Array }
type
  TBarang = record
    kode  : integer;
    nama  : string[25];
    harga : longint;
  end;

var
  barang          : array[1..MAX_BARANG] of TBarang;
  qty             : array[1..MAX_BARANG] of integer;
  totalPenjualan  : longint;
  jumlahTransaksi : integer;
  pilihan         : integer;
  garis           : string;
  i, idx, jml     : integer;
  metode, persen  : integer;
  kode            : integer;
  subtotal, diskon, total : longint; {integer tapi versi bagusnya}
  bayar, kembali, biaya   : longint;
  member          : string;
  metodeNama      : string;

begin
  clrscr;

  garis := '';
  for i := 1 to 52 do
    garis := garis + '=';

  {list kode-kode barang}
  barang[1].kode := 101; barang[1].nama := 'Beras 5 kg';       barang[1].harga := 65000;
  barang[2].kode := 102; barang[2].nama := 'Minyak Goreng 2L'; barang[2].harga := 38000;
  barang[3].kode := 103; barang[3].nama := 'Gula Pasir 1 kg';  barang[3].harga := 16000;
  barang[4].kode := 104; barang[4].nama := 'Telur 1 kg';       barang[4].harga := 28000;
  barang[5].kode := 105; barang[5].nama := 'Mie Instan';       barang[5].harga := 3500;
  barang[6].kode := 106; barang[6].nama := 'Kopi Sachet';      barang[6].harga := 2000;

  totalPenjualan  := 0;
  jumlahTransaksi := 0;

  {menu interaktif yang menggunakan Repeat-Until}
  repeat
    writeln;
    writeln(garis);
    textcolor(yellow);
    writeln('            PROGRAM KASIR (SUKI V.0.01)');
    normvideo;
    writeln(garis);
    writeln('  1. Lihat Daftar Barang');
    writeln('  2. Transaksi Baru');
    writeln('  3. Laporan Penjualan');
    writeln('  4. Keluar');
    writeln(garis);
    write('Pilih menu (1-4): ');
    readln(pilihan);
    writeln;

    {MENU 1: Daftar barang}
    if pilihan = 1 then
    begin
      textcolor(8);
      writeln(garis);
      normvideo;
      textcolor(yellow);
      writeln('DAFTAR BARANG');
      normvideo;
      textcolor(8);
      writeln(garis);
      writeln('Kode  Nama               ');
      writeln('----------------------------------------------------');
      for i := 1 to MAX_BARANG do
        writeln(barang[i].kode:4, '  ', barang[i].nama:-25,' (Rp.', barang[i].harga,')');
      writeln(garis);
      normvideo;
    end

    {MENU 2: Transaksi baru}
    else if pilihan = 2 then
    begin
      for i := 1 to MAX_BARANG do
        qty[i] := 0;
      subtotal := 0;

      textcolor(8);
      writeln(garis);
      normvideo;
      textcolor(yellow);
      writeln('DAFTAR BARANG');
      normvideo;
      textcolor(8);
      writeln(garis);
      for i := 1 to MAX_BARANG do
        writeln(barang[i].kode:4, '  ', barang[i].nama:-25, ' (Rp.',barang[i].harga,')');
      writeln(garis);
      writeln('Masukkan kode barang (0 = selesai belanja)');
      normvideo;

      { mekanisme input belanja (repeat-until + break + continue)}
      repeat
        write('Kode barang : ');
        readln(kode);
        if kode = 0 then {jika ingin keluar}
          break;                                

        { input pembelian barang berdasarkan kode }
        idx := 0;
        for i := 1 to MAX_BARANG do
          if barang[i].kode = kode then
          begin
            idx := i;
            break;           
          end;

        if idx = 0 then
        begin
          textcolor(8);
          writeln('  Kode tidak ditemukan!');
          normvideo;
          continue;                 { ulangi input }
        end;

        write('Jumlah      : ');
        readln(jml);
        if jml <= 0 then
        begin
          textcolor(8);
          writeln('  Jumlah harus lebih dari 0!');
          normvideo;
          continue;
        end;

        qty[idx] := qty[idx] + jml;
        subtotal := subtotal + jml * barang[idx].harga;
        writeln('  + ', barang[idx].nama, ' x', jml, '  | Subtotal: Rp.', subtotal);
      until kode = 0;

      if subtotal = 0 then
        writeln('Keranjang kosong, transaksi dibatalkan.')
      else
      begin
        {Diskon meningkat sesuai kentntuan (if-then-else)}
        if subtotal >= 500000 then
          persen := 15
        else if subtotal >= 250000 then
          persen := 10
        else if subtotal >= 100000 then
          persen := 5
        else
          persen := 0;

        {Nested-if: tambahan diskon untuk member }
        textcolor(8);
        write('Apakah pelanggan member? (y/n): ');
        normvideo;
        readln(member);

        if (member = 'y') or (member = 'Y') then
        begin
          if persen > 0 then
            persen := persen + 2          { sudah dapat diskon, member +2% }
          else
          begin
            if subtotal >= 50000 then
              persen := 2                 { belanja >= 50rb = member 2% }
            else
            begin
              textcolor(8);
              writeln('  (Minimal belanja Rp. 50.000 agar member dapat diskon)');
              normvideo;
              end
          end;
        end;

        diskon := subtotal * persen div 100;
        total  := subtotal - diskon;

        { Menu metode pembayaran (repeat-until + if-else) }
        writeln;
        textcolor(8);
        writeln('Metode pembayaran:');
        writeln('  1. Tunai');
        writeln('  2. Kartu Debit  (biaya admin Rp. 1.000)');
        writeln('  3. E-Wallet     (biaya admin 0,5%)');
        repeat
          write('Pilih metode (1-3): ');
          readln(metode);
          if (metode < 1) or (metode > 3) then
            writeln('  Pilihan tidak valid!');
        until (metode >= 1) and (metode <= 3);

        if metode = 1 then
        begin
          metodeNama := 'Tunai';
          biaya := 0;
        end
        else if metode = 2 then
        begin
          metodeNama := 'Kartu Debit';
          biaya := 1000;
        end
        else
        begin
          metodeNama := 'E-Wallet';
          biaya := total * 5 div 1000;
        end;

        total := total + biaya;

        writeln;
        writeln('Total yang harus dibayar: Rp.', total);

        if metode = 1 then
        begin
          repeat
            write('Uang diterima : Rp.');
            readln(bayar);
            if bayar < total then
              writeln('  Uang kurang Rp.', total - bayar);
          until bayar >= total;
          kembali := bayar - total;
        end
        else
        begin
          bayar   := total;
          kembali := 0;
          normvideo;
        end;

        {Cetak struk (for-to-do)}
        writeln;
        textcolor(11);
        writeln(garis);
        normvideo;
        textcolor(yellow);
        writeln('                 STRUK PEMBELIAN');
        normvideo;
        textcolor(11);
        writeln(garis);
        for i := 1 to MAX_BARANG do
          if qty[i] > 0 then
            writeln(barang[i].nama:-25, qty[i]:3, ' x', barang[i].harga:7, ' =', (qty[i] * barang[i].harga):9);
        writeln('----------------------------------------------------');
        writeln('Subtotal            : Rp.', subtotal:10);
        writeln('Diskon (', persen, '%)         : Rp.', diskon:10);
        writeln('Biaya admin         : Rp.', biaya:10);
        writeln('TOTAL               : Rp.', total:10);
        writeln('Metode              : ', metodeNama);
        writeln('Bayar               : Rp.', bayar:10);
        writeln('Kembalian           : Rp.', kembali:10);
        writeln(garis);
        writeln('        Terima kasih, Semoga harimu menyenagkan :)');
        normvideo;
        textcolor(11);
        writeln(garis);
        normvideo;

        {penjualan}
        totalPenjualan  := totalPenjualan + total;
        jumlahTransaksi := jumlahTransaksi + 1;
      end;
    end

    {MENU 3: Laporan penjualan}
    else if pilihan = 3 then
    begin
      textcolor(8);
      writeln(garis);
      writeln('LAPORAN PENJUALAN');
      writeln(garis);
      writeln('Jumlah transaksi   : ', jumlahTransaksi);
      writeln('Total pendapatan   : Rp.', totalPenjualan);
      if jumlahTransaksi > 0 then
        writeln('Rata-rata/transaksi: Rp.', totalPenjualan div jumlahTransaksi);
      writeln(garis);
    end

    {MENU 4: Keluar}
    else if pilihan = 4 then
    begin
      textcolor(blue);
      writeln('Program SUKI V.0.01 Berakhir.');
      normvideo;
      end
    else
      writeln('Menu tidak valid, pilih 1-4.');
  until pilihan = 4;
end.