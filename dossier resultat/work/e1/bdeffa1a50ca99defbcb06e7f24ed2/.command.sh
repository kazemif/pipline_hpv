#!/bin/bash -ue
echo "🔍 Analyse de barcode10"

mkdir -p output_barcode10

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    -i "barcode10.sam" \
    -o output_barcode10 \
    -s "barcode10" || true

CSV_FILE=$(ls output_barcode10/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode10.csv
    echo "barcode10;vide;Fichier SAM manquant ou vide" >> alignment_metrics_barcode10.csv
else
    mv "$CSV_FILE" alignment_metrics_barcode10.csv
fi
