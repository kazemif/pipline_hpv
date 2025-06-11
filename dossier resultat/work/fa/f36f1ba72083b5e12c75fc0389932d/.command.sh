#!/bin/bash -ue
echo "🔍 Traitement de barcode03"

# Nom du fichier SAM attendu (généré précédemment dans le module mapping_bam)
sam_file="./barcode03.sam"

if [ ! -s "$sam_file" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode03.csv
    echo "barcode03;vide;Fichier SAM manquant ou vide" >> alignment_metrics_barcode03.csv
    exit 0
fi

mkdir -p output_barcode03

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    -i "$sam_file" \
    -o output_barcode03 \
    -s "barcode03" || true
