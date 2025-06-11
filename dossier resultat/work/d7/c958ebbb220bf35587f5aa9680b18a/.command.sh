#!/bin/bash -ue
echo "🔍 Analyse de barcode14"

mkdir -p output_barcode14

# Lancer le script Python sur le fichier SAM
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py         -i "barcode14.sam"         -o output_barcode14         -s "barcode14" || true
