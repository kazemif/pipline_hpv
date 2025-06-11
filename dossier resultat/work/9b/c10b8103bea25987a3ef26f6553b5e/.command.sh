#!/bin/bash -ue
echo "🔍 Analyse de barcode06"

mkdir -p output_barcode06

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    -i "barcode06.sam" \
    -o output_barcode06 \
    -s "barcode06" || true

CSV_FILE=$(ls output_barcode06/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode06.csv
    echo "barcode06;vide;Fichier SAM manquant ou vide" >> alignment_metrics_barcode06.csv
else
    mv "$CSV_FILE" alignment_metrics_barcode06.csv
fi
