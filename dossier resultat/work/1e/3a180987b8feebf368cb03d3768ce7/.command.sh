#!/bin/bash -ue
echo "🔍 Analyse de barcode02"

mkdir -p output_barcode02

# Lancer le script Python sur le fichier SAM
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py         -i "barcode02.sam"         -o output_barcode02         -s "barcode02" || true
