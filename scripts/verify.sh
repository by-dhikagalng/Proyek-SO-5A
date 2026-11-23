
#!/bin/bash

# Mengambil lokasi arsip dari argumen pertama
ARCHIVE="$1"

# 1. Periksa parameter
if [ -z "$ARCHIVE" ]; then
    echo "Error: Lokasi arsip belum diberikan"
    exit 4
fi

# 2. Periksa keberadaan arsip
if [ ! -f "$ARCHIVE" ]; then
    echo "Error: File arsip tidak ditemukan"
    exit 4
fi

# 3. Periksa keberadaan file checksum
CHECKSUM_FILE="$ARCHIVE.sha256"

if [ ! -f "$CHECKSUM_FILE" ]; then
    echo "Error: File checksum tidak ditemukan"
    exit 4
fi

# 4. Periksa checksum SHA-256
ARCHIVE_DIR=$(dirname "$ARCHIVE")
ARCHIVE_NAME=$(basename "$ARCHIVE")

(
    cd "$ARCHIVE_DIR" || exit 1
    sha256sum -c "$(basename "$CHECKSUM_FILE")"
)

if [ $? -ne 0 ]; then
    echo "Error: Integritas arsip gagal"
    exit 4
fi

# 5. Periksa struktur arsip
if ! tar -tzf "$ARCHIVE" > /dev/null 2>&1; then
    echo "Error: Arsip tidak valid atau rusak"
    exit 4
fi

echo "Verifikasi berhasil: Arsip valid dan checksum cocok"
exit 0


