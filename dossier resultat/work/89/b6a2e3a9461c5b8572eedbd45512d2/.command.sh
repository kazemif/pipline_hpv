#!/bin/bash -ue
echo "🔍 Analyse de barcode10"

mkdir -p output_barcode10

# Lancer le script Python sur le fichier SAM
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py         -i "barcode10.sam"         -o output_barcode10         -s "barcode10" || true
