#!/bin/bash -ue
echo "🔍 Analyse de barcode04"

mkdir -p output_barcode04

# Lancer le script Python sur le fichier SAM
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py         -i "barcode04.sam"         -o output_barcode04         -s "barcode04" || true
