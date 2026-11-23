# Dokumentasi Restore

## Format Backup
- Format arsip: .tar.gz
- Lokasi arsip: output/
- File checksum: .sha256

## Proses Restore
1. Memeriksa keberadaan arsip.
2. Memverifikasi checksum arsip.
3. Memastikan arsip dapat dibaca.
4. Mengekstrak arsip ke restore_test/hasil/.
5. Memeriksa hasil pemulihan.

## Pengujian
- Positive Test: Arsip valid berhasil dipulihkan dengan exit status 0.
- Negative Test: Arsip rusak atau checksum tidak cocok ditolak dengan exit status 5.
- Path Security: Arsip dengan path berbahaya (../) ditolak sebelum ekstraksi dengan exit status 5.
- Data Comparison: Hasil restore dibandingkan dengan data sumber menggunakan diff -r dan dinyatakan identik.
