#!/bin/bash -ue
echo "🔍 Traitement de : barcode12"

if [ ! -s "barcode12.sorted.bam" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode12.csv
    echo "barcode12;vide;Fichier BAM vide" >> alignment_metrics_barcode12.csv
    exit 0
fi

mkdir -p output_barcode12

# 👉 Copier/renommer le BAM sans .sorted
cp "barcode12.sorted.bam" "barcode12.bam"

# Lancer le script Python sur le fichier renommé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode12.bam" \
    --output output_barcode12 \
    --sample "barcode12"

# Vérification du CSV
CSV_FILE=$(ls output_barcode12/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode12.csv
    echo "barcode12;vide;Aucune donnée analysable" >> alignment_metrics_barcode12.csv
else
    mv "$CSV_FILE" "alignment_metrics_barcode12.csv"
fi
