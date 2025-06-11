#!/bin/bash -ue
echo "🔍 Analyse de barcode13"

mkdir -p output_barcode13

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    -i "barcode13.sam" \
    -o output_barcode13 \
    -s "barcode13" || true
