#!/bin/bash -ue
echo "🔍 Traitement de barcode06"

# Nom du fichier SAM attendu (généré précédemment dans le module mapping_bam)
sam_file="./barcode06.sam"

if [ ! -s "$sam_file" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode06.csv
    echo "barcode06;vide;Fichier SAM manquant ou vide" >> alignment_metrics_barcode06.csv
    exit 0
fi

mkdir -p output_barcode06

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    -i "$sam_file" \
    -o output_barcode06 \
    -s "barcode06" || true
