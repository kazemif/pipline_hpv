#!/bin/bash -ue
echo "🔍 Traitement de barcode07"

# Nom du fichier SAM attendu (généré précédemment dans le module mapping_bam)
sam_file="./barcode07.sam"

if [ ! -s "$sam_file" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode07.csv
    echo "barcode07;vide;Fichier SAM manquant ou vide" >> alignment_metrics_barcode07.csv
    exit 0
fi

mkdir -p output_barcode07

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    -i "$sam_file" \
    -o output_barcode07 \
    -s "barcode07" || true
