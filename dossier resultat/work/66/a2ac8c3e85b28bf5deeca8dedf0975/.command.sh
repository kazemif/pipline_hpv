#!/bin/bash -ue
echo "🔍 Analyse de barcode08"

mkdir -p output_barcode08

# Lancer le script Python sur le fichier SAM
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py         -i "barcode08.sam"         -o output_barcode08         -s "barcode08" || true
