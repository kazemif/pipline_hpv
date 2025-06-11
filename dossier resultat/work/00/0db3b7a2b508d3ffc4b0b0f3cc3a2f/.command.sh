#!/bin/bash -ue
echo "🔍 Analyse de barcode01"

mkdir -p output_barcode01

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    -i "barcode01.sam" \
    -o output_barcode01 \
    -s "barcode01" || true
