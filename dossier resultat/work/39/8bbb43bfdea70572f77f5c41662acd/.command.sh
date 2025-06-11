#!/bin/bash -ue
echo "🔍 Analyse de barcode06"

mkdir -p output_barcode06

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    -i "barcode06.sam" \
    -o output_barcode06 \
    -s "barcode06" || true
