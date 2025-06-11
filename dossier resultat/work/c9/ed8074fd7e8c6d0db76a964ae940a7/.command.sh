#!/bin/bash -ue
echo "🔍 Traitement de barcode14"

# Nom du fichier SAM attendu (généré précédemment dans le module mapping_bam)
sam_file="./barcode14.sam"

if [ ! -s "$sam_file" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode14.csv
    echo "barcode14;vide;Fichier SAM manquant ou vide" >> alignment_metrics_barcode14.csv
    exit 0
fi

mkdir -p output_barcode14

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    -i "$sam_file" \
    -o output_barcode14 \
    -s "barcode14" || true

CSV_FILE=$(ls output_barcode14/*.csv 2>/dev/null || true)
if [ -z "$CSV_FILE" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode14.csv
    echo "barcode14;vide;Aucune donnée analysable" >> alignment_metrics_barcode14.csv
else
    mv "$CSV_FILE" alignment_metrics_barcode14.csv
fi
