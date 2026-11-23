#!/bin/bash

ARCHIVE="$1"
CHECKSUM="${ARCHIVE}.sha256"
DEST="restore_test/hasil"

# Memeriksa parameter
if [ -z "$ARCHIVE" ]; then
    echo "Error: Masukkan lokasi arsip backup"
    exit 2
fi

# Memeriksa keberadaan arsip
if [ ! -f "$ARCHIVE" ]; then
    echo "Error: Arsip backup tidak ditemukan"
    exit 2
fi

# Memeriksa file checksum
if [ ! -f "$CHECKSUM" ]; then
    echo "Error: File checksum tidak ditemukan"
    exit 2
fi

# Memverifikasi integritas arsip
echo "Memverifikasi arsip backup..."
if ! sha256sum -c "$CHECKSUM"; then
    echo "Error: Arsip rusak atau checksum tidak cocok"
    exit 1
fi

# Memeriksa validitas arsip
if ! tar -tzf "$ARCHIVE" > /dev/null 2>&1; then
    echo "Error: Arsip tidak valid"
    exit 1
fi

# Menyiapkan folder tujuan
mkdir -p "$DEST"

# Memulihkan arsip
if tar -xzf "$ARCHIVE" -C "$DEST"; then
    echo "Restore berhasil!"
    echo "Lokasi hasil pemulihan: $DEST"
    exit 0
else
    echo "Error: Proses restore gagal"
    exit 1
fi
