#!/bin/bash -ue
echo "🔍 Traitement de barcode05"

# Nom du fichier SAM attendu (généré précédemment dans le module mapping_bam)
sam_file="./barcode05.sam"

if [ ! -s "$sam_file" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode05.csv
    echo "barcode05;vide;Fichier SAM manquant ou vide" >> alignment_metrics_barcode05.csv
    exit 0
fi

mkdir -p output_barcode05

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    -i "$sam_file" \
    -o output_barcode05 \
    -s "barcode05" || true

CSV_FILE=$(ls output_barcode05/*.csv 2>/dev/null || true)
if [ -z "$CSV_FILE" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode05.csv
    echo "barcode05;vide;Aucune donnée analysable" >> alignment_metrics_barcode05.csv
else
    mv "$CSV_FILE" alignment_metrics_barcode05.csv
fi
