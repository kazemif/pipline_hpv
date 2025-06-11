#!/bin/bash -ue
echo "🔍 Traitement de : barcode16"

if [ ! -s "barcode16.sorted.bam" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode16.csv
    echo "barcode16;vide;Fichier BAM vide" >> alignment_metrics_barcode16.csv
    exit 0
fi

# Créer le dossier de sortie pour Python
mkdir -p output_barcode16

# Copier/renommer le BAM sans .sorted
cp "barcode16.sorted.bam" "barcode16.bam"

# Lancer le script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode16.bam" \
    --output output_barcode16 \
    --sample "barcode16"

# Vérifier si un CSV a été généré
CSV_FILE=$(ls output_barcode16/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo "sample_id;status;note" > alignment_metrics_barcode16.csv
    echo "barcode16;vide;Aucune donnée analysable" >> alignment_metrics_barcode16.csv
else
    mv "$CSV_FILE" "alignment_metrics_barcode16.csv"
fi
