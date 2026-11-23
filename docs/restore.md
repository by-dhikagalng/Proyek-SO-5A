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
- Positive Test: arsip valid berhasil dipulihkan.
- Negative Test: arsip rusak ditolak.
