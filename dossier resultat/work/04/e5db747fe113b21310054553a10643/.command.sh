#!/bin/bash -ue
echo "🔍 Traitement de : barcode08"

if [ ! -s "barcode08.sorted.bam" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode08.csv
    echo "barcode08;vide;Fichier BAM vide" >> alignment_metrics_barcode08.csv
    exit 0
fi

# Créer le dossier de sortie pour Python
mkdir -p output_barcode08

# Copier/renommer le BAM sans .sorted
cp "barcode08.sorted.bam" "barcode08.bam"

# Lancer le script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode08.bam" \
    --output output_barcode08 \
    --sample "barcode08"

# Vérifier si un CSV a été généré
CSV_FILE=$(ls output_barcode08/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo "sample_id;status;note" > alignment_metrics_barcode08.csv
    echo "barcode08;vide;Aucune donnée analysable" >> alignment_metrics_barcode08.csv
else
    mv "$CSV_FILE" "alignment_metrics_barcode08.csv"
fi
