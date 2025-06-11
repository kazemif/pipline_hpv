#!/bin/bash -ue
echo "🔍 Analyse de barcode15"

mkdir -p output_barcode15

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    -i "barcode15.sam" \
    -o output_barcode15 \
    -s "barcode15" || true
