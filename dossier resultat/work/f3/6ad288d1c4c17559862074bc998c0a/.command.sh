#!/bin/bash -ue
echo "🔍 Traitement de : barcode01"

# Vérifie si le fichier BAM est vide
if [ ! -s "barcode01.sorted.bam" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode01.csv
    echo "barcode01;vide;Fichier BAM vide" >> alignment_metrics_barcode01.csv
    exit 0
fi

# Créer le dossier de sortie
mkdir -p output_barcode01

# Copier le fichier BAM avec un nom standard pour le script
cp "barcode01.sorted.bam" "barcode01.bam"

# Exécution du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode01.bam" \
    --output output_barcode01 \
    --sample "barcode01" || true

# Récupération du fichier CSV de sortie
CSV_FILE=$(find output_barcode01 -type f -name "*.csv" 2>/dev/null | head -n 1)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo "sample_id;status;note" > alignment_metrics_barcode01.csv
    echo "barcode01;vide;Aucune donnée analysable" >> alignment_metrics_barcode01.csv
else
    mv "$CSV_FILE" "alignment_metrics_barcode01.csv"
fi
