#!/bin/bash

SOURCE="$1"

if [ -z "$SOURCE" ]; then
    echo "Error: Parameter folder sumber belum diberikan"
    exit 2
fi

if [ ! -d "$SOURCE" ]; then
    echo "Error: Folder sumber tidak ditemukan"
    exit 2
fi

if [ -z "$(ls -A "$SOURCE")" ]; then
    echo "Error: Folder sumber kosong"
    exit 2
fi

echo "Validasi berhasil: $SOURCE"
exit 0
