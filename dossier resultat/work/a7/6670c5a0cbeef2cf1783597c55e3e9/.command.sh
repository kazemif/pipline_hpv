#!/bin/bash -ue
echo "🔍 Traitement de : barcode06"

if [ ! -s "barcode06.sorted.bam" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode06.csv
    echo "barcode06;vide;Fichier BAM vide" >> alignment_metrics_barcode06.csv
    exit 0
fi

# Créer le dossier de sortie pour Python
mkdir -p output_barcode06

# Copier/renommer le BAM sans .sorted
cp "barcode06.sorted.bam" "barcode06.bam"

# Lancer le script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode06.bam" \
    --output output_barcode06 \
    --sample "barcode06"

# Vérifier si un CSV a été généré
CSV_FILE=$(ls output_barcode06/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo "sample_id;status;note" > alignment_metrics_barcode06.csv
    echo "barcode06;vide;Aucune donnée analysable" >> alignment_metrics_barcode06.csv
else
    mv "$CSV_FILE" "alignment_metrics_barcode06.csv"
fi
