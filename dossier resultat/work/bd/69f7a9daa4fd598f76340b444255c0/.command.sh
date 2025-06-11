#!/bin/bash -ue
echo "🔍 Traitement de : barcode02"

# Vérifie si le fichier BAM est vide
if [ ! -s "barcode02.sorted.bam" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode02.csv
    echo "barcode02;vide;Fichier BAM vide" >> alignment_metrics_barcode02.csv
    exit 0
fi

# Créer le dossier de sortie
mkdir -p output_barcode02

# Copier le fichier BAM avec un nom standard pour le script
cp "barcode02.sorted.bam" "barcode02.bam"

# Exécution du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode02.bam" \
    --output output_barcode02 \
    --sample "barcode02" || true

# Récupération du fichier CSV de sortie
CSV_FILE=$(find output_barcode02 -type f -name "*.csv" 2>/dev/null | head -n 1)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo "sample_id;status;note" > alignment_metrics_barcode02.csv
    echo "barcode02;vide;Aucune donnée analysable" >> alignment_metrics_barcode02.csv
else
    mv "$CSV_FILE" "alignment_metrics_barcode02.csv"
fi
