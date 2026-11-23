Analisis Pemulihan Data dan Keamanan Ekstraksi

Proses restore digunakan untuk mengembalikan data dari arsip backup ke direktori tujuan. Sebelum ekstraksi, sistem memeriksa checksum dan validitas arsip.

Keamanan ekstraksi dilakukan dengan menolak path berbahaya seperti ../ agar file tidak keluar dari direktori tujuan. Hasil restore juga dibandingkan dengan data sumber menggunakan diff -r.
