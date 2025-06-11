#!/bin/bash -ue
echo "🔍 Traitement de barcode08"

# Nom du fichier SAM attendu (généré précédemment dans le module mapping_bam)
sam_file="./barcode08.sam"

if [ ! -s "$sam_file" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode08.csv
    echo "barcode08;vide;Fichier SAM manquant ou vide" >> alignment_metrics_barcode08.csv
    exit 0
fi

mkdir -p output_barcode08

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    -i "$sam_file" \
    -o output_barcode08 \
    -s "barcode08" || true
