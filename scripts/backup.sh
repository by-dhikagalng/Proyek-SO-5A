#!/bin/bash

SOURCE="$1"
DEST="$2"

if [ -z "$SOURCE" ] || [ -z "$DEST" ]; then
    echo "Error: penggunaan backup.sh <source> <destination>"
    exit 3
fi

if [ ! -d "$SOURCE" ]; then
    echo "Error: folder sumber tidak ditemukan"
    exit 3
fi

if [ -z "$(ls -A "$SOURCE")" ]; then
    echo "Error: folder sumber kosong"
    exit 3
fi

mkdir -p "$DEST"

if [ ! -w "$DEST" ]; then
    echo "Error: folder tujuan tidak bisa ditulis"
    exit 3
fi

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE="$DEST/backup_$TIMESTAMP.tar.gz"

tar -czf "$ARCHIVE" -C "$(dirname "$SOURCE")" "$(basename "$SOURCE")"

if [ $? -ne 0 ]; then
    echo "Error: proses backup gagal"
    exit 3
fi

echo "Backup berhasil: $ARCHIVE"
exit 0
