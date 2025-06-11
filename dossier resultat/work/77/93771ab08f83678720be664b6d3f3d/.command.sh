#!/bin/bash -ue
echo "🔍 Traitement de : barcode09"

if [ ! -s "barcode09.sorted.bam" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode09.csv
    echo "barcode09;vide;Fichier BAM vide" >> alignment_metrics_barcode09.csv
    exit 0
fi

# Créer le dossier de sortie pour Python
mkdir -p output_barcode09

# Copier/renommer le BAM sans .sorted
cp "barcode09.sorted.bam" "barcode09.bam"

# Lancer le script Python (🔥 Ajout || true pour ne pas bloquer)
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode09.bam" \
    --output output_barcode09 \
    --sample "barcode09" || true

# Vérifier si un CSV a été généré
CSV_FILE=$(ls output_barcode09/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo "sample_id;status;note" > alignment_metrics_barcode09.csv
    echo "barcode09;vide;Aucune donnée analysable" >> alignment_metrics_barcode09.csv
else
    mv "$CSV_FILE" "alignment_metrics_barcode09.csv"
fi
