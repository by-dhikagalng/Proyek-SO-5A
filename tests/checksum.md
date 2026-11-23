# Dokumentasi Pengujian Checksum SHA-256

## 1. Tujuan Pengujian

Pengujian ini bertujuan untuk memastikan integritas file backup menggunakan algoritma SHA-256. Proses verifikasi dilakukan dengan membandingkan nilai checksum pada file arsip dengan nilai checksum yang tersimpan dalam file berekstensi `.sha256`.

Selain itu, script `verify.sh` juga melakukan pemeriksaan terhadap keberadaan arsip, keberadaan file checksum, dan validitas struktur arsip menggunakan perintah `tar`.

## 2. Implementasi Program

File yang digunakan:

```text
scripts/verify.sh
```

Script memiliki beberapa tahapan pemeriksaan:

1. **Pemeriksaan parameter:** memastikan lokasi arsip diberikan sebagai argumen.
2. **Pemeriksaan keberadaan arsip:** memastikan file arsip tersedia.
3. **Pemeriksaan file checksum:** memastikan file `.sha256` tersedia.
4. **Verifikasi SHA-256:** membandingkan checksum arsip dengan checksum yang tersimpan.
5. **Pemeriksaan struktur arsip:** menggunakan `tar -tzf` untuk memastikan arsip dapat dibaca dan memiliki struktur yang valid.

Jika seluruh pemeriksaan berhasil, program mengembalikan exit status `0`. Jika terjadi kesalahan, program mengembalikan exit status `4`.

## 3. Pengujian Positif

### Skenario
Memastikan file backup yang belum mengalami perubahan dapat diverifikasi dengan benar.

### Langkah Pengujian

1. Membuat file data pengujian.
2. Membuat arsip menggunakan perintah `tar`.
3. Membuat checksum SHA-256 menggunakan `sha256sum`.
4. Menjalankan script `verify.sh`.

Perintah yang digunakan:

```bash
mkdir -p tests/checksum

echo "Ini data untuk pengujian checksum" > tests/checksum/data.txt

tar -czf tests/checksum/backup_dummy.tar.gz -C tests/checksum data.txt

cd tests/checksum

sha256sum backup_dummy.tar.gz > backup_dummy.tar.gz.sha256

cd ../..

./scripts/verify.sh tests/checksum/backup_dummy.tar.gz
```

### Hasil Pengujian

```text
backup_dummy.tar.gz: OK
Verifikasi berhasil: Arsip valid dan checksum cocok
```

**Exit status:**

```bash
echo $?
```

Hasil:

```text
0
```

### Analisis

Pengujian berhasil karena nilai checksum SHA-256 pada arsip sesuai dengan nilai yang tersimpan dalam file checksum. Selain itu, struktur arsip dapat dibaca menggunakan perintah `tar -tzf`.

Dengan demikian, arsip dinyatakan valid dan proses verifikasi berhasil.

## 4. Pengujian Negatif

### Skenario
Memastikan program dapat mendeteksi perubahan pada file arsip setelah checksum dibuat.

### Langkah Pengujian

1. Mengubah isi file arsip menggunakan perintah `echo`.
2. Menjalankan kembali script `verify.sh`.
3. Memeriksa hasil verifikasi dan exit status.

Perintah yang digunakan:

```bash
echo "Data telah dimodifikasi" >> tests/checksum/backup_dummy.tar.gz

./scripts/verify.sh tests/checksum/backup_dummy.tar.gz
```

### Hasil Pengujian

```text
backup_dummy.tar.gz: FAILED
sha256sum: WARNING: 1 computed checksum did NOT match
Error: Integritas arsip gagal
```

**Exit status:**

```bash
echo $?
```

Hasil:

```text
4
```

### Analisis

Pengujian menunjukkan bahwa program berhasil mendeteksi perubahan pada file arsip. Setelah isi arsip dimodifikasi, nilai checksum yang dihasilkan tidak lagi sesuai dengan nilai checksum sebelumnya.

Akibatnya, proses verifikasi dihentikan dan program mengembalikan exit status `4`.

Hal ini menunjukkan bahwa mekanisme SHA-256 dapat membantu mendeteksi perubahan atau kerusakan pada file backup.

## 5. Kesimpulan

Berdasarkan pengujian positif dan negatif, script `verify.sh` dapat menjalankan fungsi pemeriksaan integritas file backup menggunakan SHA-256.

Pada pengujian positif, arsip yang tidak mengalami perubahan berhasil diverifikasi dengan exit status `0`. Sementara itu, pada pengujian negatif, perubahan isi arsip berhasil terdeteksi dan menghasilkan exit status `4`.

Pemeriksaan struktur arsip menggunakan perintah `tar -tzf` juga membantu memastikan bahwa file backup merupakan arsip yang dapat dibaca.

Dengan demikian, fitur verifikasi checksum dapat digunakan sebagai salah satu mekanisme untuk menjaga integritas data dalam proses backup dan restore.
