#!/bin/bash -ue
echo "🔍 Traitement de : barcode10"

if [ ! -s "barcode10.sorted.bam" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode10.csv
    echo "barcode10;vide;Fichier BAM vide" >> alignment_metrics_barcode10.csv
    exit 0
fi

mkdir -p output_barcode10

# 👉 Copier/renommer le BAM sans .sorted
cp "barcode10.sorted.bam" "barcode10.bam"

# Lancer le script Python sur le fichier renommé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode10.bam" \
    --output output_barcode10 \
    --sample "barcode10"

# Vérification du CSV
CSV_FILE=$(ls output_barcode10/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode10.csv
    echo "barcode10;vide;Aucune donnée analysable" >> alignment_metrics_barcode10.csv
else
    mv "$CSV_FILE" "alignment_metrics_barcode10.csv"
fi
