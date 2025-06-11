#!/bin/bash -ue
echo "🔍 Analyse de barcode16"

mkdir -p output_barcode16

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    -i "barcode16.sam" \
    -o output_barcode16 \
    -s "barcode16" || true

CSV_FILE=$(ls output_barcode16/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode16.csv
    echo "barcode16;vide;Fichier SAM manquant ou vide" >> alignment_metrics_barcode16.csv
else
    mv "$CSV_FILE" alignment_metrics_barcode16.csv
fi
