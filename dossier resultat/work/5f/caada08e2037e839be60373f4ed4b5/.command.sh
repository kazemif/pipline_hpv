#!/bin/bash -ue
echo "🔍 Analyse de barcode03"

mkdir -p output_barcode03

# Lancer le script Python sur le fichier SAM
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py         -i "barcode03.sam"         -o output_barcode03         -s "barcode03" || true
