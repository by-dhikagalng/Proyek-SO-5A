#!/bin/bash

while true
do
    echo "=============================="
    echo " BACKUP & RESTORE SYSTEM"
    echo "=============================="
    echo "1. Validasi folder"
    echo "2. Backup"
    echo "3. Verifikasi"
    echo "4. Restore"
    echo "5. Keluar"
    read -p "Pilih menu: " pilihan

    case "$pilihan" in
        1)
            ./scripts/validate.sh data/dokumen
            ;;
        2)
            ./scripts/backup.sh data/dokumen output
            ;;
        3)
            read -p "Masukkan nama arsip: " arsip
            ./scripts/verify.sh "$arsip"
            ;;
        4)
            read -p "Masukkan nama arsip: " arsip
            ./scripts/restore.sh "$arsip" restore_test
            ;;
        5)
            echo "Program selesai"
            break
            ;;
        *)
            echo "Pilihan tidak valid"
            ;;
    esac
done
