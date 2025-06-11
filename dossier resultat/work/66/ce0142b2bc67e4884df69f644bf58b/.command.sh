#!/bin/bash -ue
echo "🔍 Analyse de barcode05"

mkdir -p output_barcode05

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    -i "barcode05.sam" \
    -o output_barcode05 \
    -s "barcode05" || true
