#!/bin/bash -ue
echo "🔍 Analyse de barcode16"

mkdir -p output_barcode16

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    -i "barcode16.sam" \
    -o output_barcode16 \
    -s "barcode16" || true
