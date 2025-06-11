#!/bin/bash -ue
echo "🔍 Analyse de barcode09"

mkdir -p output_barcode09

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    -i "barcode09.sam" \
    -o output_barcode09 \
    -s "barcode09" || true
