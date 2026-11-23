# Dokumentasi Pengujian Validasi

## 1. Positive Test

### Skenario
Pengujian dilakukan menggunakan folder `data/dokumen` yang berisi data.

### Perintah
```bash
./scripts/validate.sh data/dokumen
echo $?
```

### Hasil
```text
Validasi berhasil: data/dokumen
0
```

### Kesimpulan
Folder sumber yang tersedia dan memiliki isi berhasil diterima oleh script validasi dengan exit status `0`.

## 2. Negative Test

### Skenario
Pengujian dilakukan menggunakan folder `data/kosong` yang tidak memiliki data. File `.gitkeep` yang terdapat di dalam folder tidak dianggap sebagai data oleh script validasi.

### Perintah
```bash
./scripts/validate.sh data/kosong
echo $?
```

### Hasil
```text
Error: Folder sumber kosong
2
```

### Kesimpulan
Folder sumber yang tidak memiliki data ditolak oleh script validasi dengan exit status `2`.

## 3. Analisis Sistem Berkas

Validasi sumber berkaitan dengan sistem berkas Linux, khususnya pemeriksaan path, direktori, keberadaan objek, dan isi direktori.

Script `validate.sh` menerima path folder sumber melalui parameter. Script kemudian memeriksa apakah parameter telah diberikan dan apakah path tersebut merupakan direktori yang tersedia.

Setelah itu, script memeriksa isi direktori. Folder yang tidak memiliki data dianggap kosong dan proses validasi dihentikan dengan exit status non-zero. Folder yang memiliki data dapat dilanjutkan ke proses backup.

Penggunaan pemeriksaan direktori dan isi direktori tersebut merupakan bentuk perlindungan pada tahap awal agar proses backup tidak dijalankan terhadap sumber yang tidak valid atau kosong.

## 4. Kaitan dengan Proyek

Validasi sistem berkas diperlukan sebelum proses backup untuk memastikan sumber data yang digunakan benar-benar tersedia dan memiliki data yang dapat diproses. Dengan validasi ini, kesalahan input sumber dapat ditangani lebih awal sebelum proses backup dijalankan.
