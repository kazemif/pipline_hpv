#!/bin/bash -ue
echo "🔍 Traitement de : barcode02"

if [ ! -s "barcode02.sorted.bam" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode02.csv
    echo "barcode02;vide;Fichier BAM vide" >> alignment_metrics_barcode02.csv
    exit 0
fi

# Créer le dossier de sortie pour Python
mkdir -p output_barcode02

# Copier/renommer le BAM sans .sorted
cp "barcode02.sorted.bam" "barcode02.bam"

# Lancer le script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode02.bam" \
    --output output_barcode02 \
    --sample "barcode02"

# Vérifier si un CSV a été généré
CSV_FILE=$(ls output_barcode02/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo "sample_id;status;note" > alignment_metrics_barcode02.csv
    echo "barcode02;vide;Aucune donnée analysable" >> alignment_metrics_barcode02.csv
else
    mv "$CSV_FILE" "alignment_metrics_barcode02.csv"
fi
