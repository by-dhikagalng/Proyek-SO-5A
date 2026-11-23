
#!/bin/bash

set -o pipefail

ARCHIVE="${1:-}"
DEST="${2:-restore_test/hasil}"

# Menentukan lokasi root proyek
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERIFY_SCRIPT="$PROJECT_DIR/scripts/verify.sh"

# Validasi parameter
if [ -z "$ARCHIVE" ]; then
    echo "Error: Masukkan lokasi arsip backup"
    exit 2
fi

# Validasi file arsip
if [ ! -f "$ARCHIVE" ]; then
    echo "Error: Arsip backup tidak ditemukan"
    exit 2
fi

# Menggunakan verify.sh sebagai satu sumber verifikasi
echo "Memverifikasi integritas arsip..."

if ! bash "$VERIFY_SCRIPT" "$ARCHIVE"; then
    echo "Error: Verifikasi arsip gagal"
    exit 1
fi

# Pemeriksaan dasar keamanan isi arsip
if ! python3 - "$ARCHIVE" <<'PY'
import sys
import tarfile
from pathlib import PurePosixPath

archive = sys.argv[1]

try:
    with tarfile.open(archive, "r:gz") as tar:
        for member in tar:
            path = PurePosixPath(member.name)

            if (
                path.is_absolute()
                or ".." in path.parts
                or not (member.isfile() or member.isdir())
            ):
                raise ValueError(
                    f"Entri tidak aman: {member.name}"
                )

except (OSError, tarfile.TarError, ValueError) as e:
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(1)
PY
then
    echo "Error: Arsip tidak aman untuk diekstrak"
    exit 1
fi

# Pastikan tujuan bukan symbolic link
if [ -L "$DEST" ]; then
    echo "Error: Folder tujuan tidak boleh symbolic link"
    exit 1
fi

# Siapkan tujuan restore
if ! mkdir -p "$DEST"; then
    echo "Error: Gagal membuat folder restore"
    exit 1
fi

# Ekstraksi arsip
if tar --no-same-owner --no-same-permissions \
    -xzf "$ARCHIVE" -C "$DEST"; then
    echo "Restore berhasil!"
    echo "Lokasi hasil pemulihan: $DEST"
    exit 0
else
    echo "Error: Proses restore gagal"
    exit 1
fi

