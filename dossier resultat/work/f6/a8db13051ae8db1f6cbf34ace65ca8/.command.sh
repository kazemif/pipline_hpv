#!/bin/bash -ue
echo "🔍 Traitement de : barcode15"

# Vérifie si le fichier BAM est vide
if [ ! -s "barcode15.sorted.bam" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode15.csv
    echo "barcode15;vide;Fichier BAM vide" >> alignment_metrics_barcode15.csv
    exit 0
fi

# Créer le dossier de sortie
mkdir -p output_barcode15

# Copier le fichier BAM avec un nom standard pour le script
cp "barcode15.sorted.bam" "barcode15.bam"

# Exécution du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode15.bam" \
    --output output_barcode15 \
    --sample "barcode15" || true

# Récupération du fichier CSV de sortie
CSV_FILE=$(find output_barcode15 -type f -name "*.csv" 2>/dev/null | head -n 1)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo "sample_id;status;note" > alignment_metrics_barcode15.csv
    echo "barcode15;vide;Aucune donnée analysable" >> alignment_metrics_barcode15.csv
else
    mv "$CSV_FILE" "alignment_metrics_barcode15.csv"
fi
