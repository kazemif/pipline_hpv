#!/bin/bash -ue
echo "🔍 Analyse de barcode07"

mkdir -p output_barcode07

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    -i "barcode07.sam" \
    -o output_barcode07 \
    -s "barcode07" || true

CSV_FILE=$(ls output_barcode07/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode07.csv
    echo "barcode07;vide;Fichier SAM manquant ou vide" >> alignment_metrics_barcode07.csv
else
    mv "$CSV_FILE" alignment_metrics_barcode07.csv
fi
