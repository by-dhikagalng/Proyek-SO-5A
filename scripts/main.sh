#!/bin/bash

cd "$(dirname "$0")/.." || exit 1

mkdir -p logs output
LOG_FILE="logs/activity.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" \
      | tee -a "$LOG_FILE"
}


run_script() {
    local script="$1"
    shift

    if [ ! -s "$script" ]; then
        log "ERROR: $script belum diimplementasikan"
        return 1
    fi

    if [[ "$script" == "scripts/backup.sh" ||
          "$script" == "scripts/restore.sh" ]]; then

        local lock_file="/tmp/proyek-so-5a.lock"

        flock -n -E 75 "$lock_file" bash "$script" "$@"
        local status=$?

        if [ "$status" -eq 75 ]; then
            log "ERROR: Operasi ditolak, proses lain masih berjalan"
            return 75
        fi
    else
        bash "$script" "$@"
        local status=$?
    fi

    log "Script $script selesai dengan exit status $status"
    return "$status"
}


while true; do
    echo ""
    echo "===== BACKUP & RESTORE SYSTEM ====="
    echo "1. Validasi"
    echo "2. Backup"
    echo "3. Verifikasi"
    echo "4. Restore"
    echo "5. Keluar"

    read -r -p "Pilih menu: " pilihan || break

    case "$pilihan" in
        1)
            run_script scripts/validate.sh data/dokumen
            ;;
        2)
            run_script scripts/backup.sh data/dokumen output
            ;;
        3)
            read -r -p "Path arsip: " arsip
            run_script scripts/verify.sh "$arsip"
            ;;
        4)
            read -r -p "Path arsip: " arsip
            run_script scripts/restore.sh "$arsip" restore_test
            ;;
        5)
            log "Program dihentikan pengguna"
            break
            ;;
        *)
            log "ERROR: Pilihan menu tidak valid"
            ;;
    esac
done
