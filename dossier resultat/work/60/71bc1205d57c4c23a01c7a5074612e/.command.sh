#!/bin/bash -ue
echo "🔍 Analyse de barcode12"

mkdir -p output_barcode12

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    -i "barcode12.sam" \
    -o output_barcode12 \
    -s "barcode12" || true
