# Analisis Awal Sistem Backup dan Pemulihan Data

## 1. Analisis Modul Backup

### 1.1 Tujuan

Modul backup dibuat untuk mencadangkan data dari direktori sumber ke direktori tujuan dalam bentuk arsip terkompresi `.tar.gz`. Fitur ini bertujuan menyediakan salinan data yang dapat digunakan kembali apabila terjadi kehilangan atau kerusakan data.

### 1.2 Analisis Kebutuhan

Modul backup membutuhkan beberapa fungsi utama, yaitu:

- Menerima direktori sumber dan direktori tujuan sebagai parameter.
- Memeriksa keberadaan direktori sumber.
- Memastikan direktori sumber tidak kosong.
- Memastikan direktori tujuan dapat ditulisi.
- Membuat arsip backup dengan format `.tar.gz`.
- Memberikan nama file backup berdasarkan tanggal dan waktu.
- Menampilkan pesan keberhasilan atau kesalahan proses.
- Menggunakan exit code untuk menunjukkan status proses.

### 1.3 Rancangan Proses Backup

Proses backup dirancang melalui beberapa tahapan. Pertama, pengguna menjalankan script `backup.sh` dengan memasukkan direktori sumber dan tujuan. Selanjutnya, sistem memeriksa kelengkapan parameter, keberadaan direktori sumber, serta kondisi direktori sumber apakah kosong atau tidak.

Setelah validasi sumber selesai, sistem membuat direktori tujuan apabila belum tersedia dan memeriksa izin tulisnya. Jika seluruh pemeriksaan berhasil, sistem menjalankan perintah `tar` untuk mengompresi direktori sumber menjadi arsip `.tar.gz`. File backup kemudian disimpan pada direktori tujuan dengan nama berdasarkan tanggal dan waktu pembuatan.

### 1.4 Penanganan Kesalahan

Script backup dirancang untuk menangani beberapa kondisi kesalahan, seperti parameter yang tidak lengkap, direktori sumber yang tidak ditemukan, direktori sumber kosong, serta direktori tujuan yang tidak memiliki izin tulis.

Apabila salah satu kondisi tersebut ditemukan, sistem akan menghentikan proses backup dan menampilkan pesan kesalahan. Script menggunakan exit code 3 untuk menunjukkan kegagalan dan exit code 0 untuk menunjukkan proses backup berhasil.

## 2. Analisis Permission dan Docker

Pengaturan permission diperlukan untuk memastikan proses backup hanya dapat dilakukan apabila direktori tujuan memiliki izin tulis. Pengujian dilakukan dengan mengubah permission direktori tujuan menjadi read-only sehingga script dapat diperiksa kemampuannya dalam mendeteksi keterbatasan akses tersebut.

Selain itu, Docker digunakan untuk menguji mekanisme read-only bind mount. Direktori hasil backup dihubungkan ke dalam container menggunakan opsi `readonly`. Dengan pengaturan ini, container tetap dapat mengakses data, tetapi tidak dapat mengubah atau menambahkan file ke direktori yang dihubungkan.

### 2.1 Rencana Pengujian Backup

Pengujian modul backup meliputi beberapa skenario, yaitu:

1. Backup normal untuk memastikan direktori sumber berhasil dikompresi menjadi arsip `.tar.gz`.
2. Pengujian direktori sumber kosong untuk memastikan sistem menolak proses backup.
3. Pengujian direktori tujuan read-only untuk memastikan sistem mendeteksi direktori yang tidak dapat ditulisi.
4. Pemeriksaan isi arsip menggunakan perintah `tar -tzf` untuk memastikan file dan subdirektori berhasil dicadangkan.
5. Pengujian Docker read-only bind mount untuk memastikan container tidak dapat mengubah file pada direktori host yang di-mount sebagai read-only.

### 2.2 File yang Dikerjakan

File utama yang dikerjakan adalah `scripts/backup.sh`, yaitu script yang menangani proses validasi direktori, pencadangan, dan kompresi data. Direktori `output/` digunakan sebagai tempat penyimpanan hasil backup selama proses pengujian.

## 3. Analisis Modul Restore

Proses restore digunakan untuk mengembalikan data dari arsip backup ke direktori tujuan. Sebelum ekstraksi, sistem memeriksa checksum dan validitas arsip.

Keamanan ekstraksi dilakukan dengan menolak path berbahaya seperti `../` agar file tidak keluar dari direktori tujuan. Hasil restore juga dibandingkan dengan data sumber menggunakan `diff -r`.

## 4. Kaitan Antar-Modul

Modul backup menghasilkan arsip `.tar.gz` yang menjadi sumber bagi proses verifikasi dan restore. Setelah backup dibuat, integritas arsip dapat diperiksa menggunakan checksum sebelum arsip digunakan untuk pemulihan data.

Dengan demikian, proses backup dan restore saling berkaitan dalam membentuk alur pemulihan data. Backup menyediakan salinan data, verifikasi memastikan integritas arsip, sedangkan restore mengembalikan data ke direktori tujuan dengan memperhatikan keamanan proses ekstraksi.
