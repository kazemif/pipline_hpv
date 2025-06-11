#!/bin/bash -ue
echo "🔍 Traitement de : barcode13"

if [ ! -s "barcode13.sorted.bam" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode13.csv
    echo "barcode13;vide;Fichier BAM vide" >> alignment_metrics_barcode13.csv
    exit 0
fi

# Créer le dossier de sortie pour Python
mkdir -p output_barcode13

# Copier/renommer le BAM sans .sorted
cp "barcode13.sorted.bam" "barcode13.bam"

# Lancer le script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode13.bam" \
    --output output_barcode13 \
    --sample "barcode13"

# Vérifier si un CSV a été généré
CSV_FILE=$(ls output_barcode13/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo "sample_id;status;note" > alignment_metrics_barcode13.csv
    echo "barcode13;vide;Aucune donnée analysable" >> alignment_metrics_barcode13.csv
else
    mv "$CSV_FILE" "alignment_metrics_barcode13.csv"
fi
