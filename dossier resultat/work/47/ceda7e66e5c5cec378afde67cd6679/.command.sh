#!/bin/bash -ue
echo "🔍 Analyse de barcode07"

mkdir -p output_barcode07

# Lancer le script Python sur le fichier SAM
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py         -i "barcode07.sam"         -o output_barcode07         -s "barcode07" || true
