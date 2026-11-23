
#!/bin/bash

ARCHIVE="$1"
DEST="${2:-restore_test}"

# 1. Memeriksa parameter
if [ -z "$ARCHIVE" ]; then
    echo "Error: Masukkan lokasi arsip backup"
    exit 2
fi

# 2. Memeriksa keberadaan arsip
if [ ! -f "$ARCHIVE" ]; then
    echo "Error: Arsip backup tidak ditemukan"
    exit 2
fi

# 3. Memeriksa file checksum
CHECKSUM="${ARCHIVE}.sha256"

if [ ! -f "$CHECKSUM" ]; then
    echo "Error: File checksum tidak ditemukan"
    exit 2
fi

# 4. Memverifikasi checksum
echo "Memverifikasi arsip backup..."

if ! sha256sum -c "$CHECKSUM"; then
    echo "Error: Checksum tidak cocok"
    exit 5
fi

# 5. Memeriksa validitas arsip
if ! tar -tzf "$ARCHIVE" > /dev/null 2>&1; then
    echo "Error: Arsip tidak valid"
    exit 5
fi

# Memeriksa path berbahaya
if tar -tzf "$ARCHIVE" | awk '
    /^\// { bad=1 }
    {
        n=split($0, part, "/")
        for (i=1; i<=n; i++) {
            if (part[i] == "..") bad=1
        }
    }
    END { exit bad ? 0 : 1 }
'; then
    echo "Error: Ditemukan path berbahaya dalam arsip"
    exit 5
fi

# 6. Menyiapkan direktori tujuan
mkdir -p "$DEST"

if [ ! -d "$DEST" ] || [ ! -w "$DEST" ]; then
    echo "Error: Direktori tujuan tidak dapat digunakan"
    exit 5
fi

# Mengekstrak arsip
if tar -xzf "$ARCHIVE" -C "$DEST"; then
    echo "Restore berhasil!"
    echo "Lokasi hasil pemulihan: $DEST"
    exit 0
else
    echo "Error: Proses restore gagal"
    exit 5
fi

