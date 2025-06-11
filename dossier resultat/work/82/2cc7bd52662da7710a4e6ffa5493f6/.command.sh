#!/bin/bash -ue
echo "🔍 Analyse de barcode11"

mkdir -p output_barcode11

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    -i "barcode11.sam" \
    -o output_barcode11 \
    -s "barcode11" || true
