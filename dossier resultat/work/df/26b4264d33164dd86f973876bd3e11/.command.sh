#!/bin/bash -ue
echo "🔍 Traitement de : barcode14"

if [ ! -s "barcode14.sorted.bam" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode14.csv
    echo "barcode14;vide;Fichier BAM vide" >> alignment_metrics_barcode14.csv
    exit 0
fi

# Créer le dossier de sortie pour Python
mkdir -p output_barcode14

# Copier/renommer le BAM sans .sorted
cp "barcode14.sorted.bam" "barcode14.bam"

# Lancer le script Python (🔥 Ajout || true pour ne pas bloquer)
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode14.bam" \
    --output output_barcode14 \
    --sample "barcode14" || true

# Vérifier si un CSV a été généré
CSV_FILE=$(ls output_barcode14/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo "sample_id;status;note" > alignment_metrics_barcode14.csv
    echo "barcode14;vide;Aucune donnée analysable" >> alignment_metrics_barcode14.csv
else
    mv "$CSV_FILE" "alignment_metrics_barcode14.csv"
fi
