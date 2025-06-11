#!/bin/bash -ue
echo "🔍 Traitement de : barcode04"

if [ ! -s "barcode04.sorted.bam" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode04.csv
    echo "barcode04;vide;Fichier BAM vide" >> alignment_metrics_barcode04.csv
    exit 0
fi

mkdir -p output_barcode04

# 👉 Copier/renommer le BAM sans .sorted
cp "barcode04.sorted.bam" "barcode04.bam"

# Lancer le script Python sur le fichier renommé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode04.bam" \
    --output output_barcode04 \
    --sample "barcode04"

# Vérification du CSV
CSV_FILE=$(ls output_barcode04/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode04.csv
    echo "barcode04;vide;Aucune donnée analysable" >> alignment_metrics_barcode04.csv
else
    mv "$CSV_FILE" "alignment_metrics_barcode04.csv"
fi
