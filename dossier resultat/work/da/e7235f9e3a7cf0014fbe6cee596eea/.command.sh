#!/bin/bash -ue
echo "🔍 Traitement de : barcode09"

# Vérifie si le fichier BAM est vide
if [ ! -s "barcode09.sorted.bam" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode09.csv
    echo "barcode09;vide;Fichier BAM vide" >> alignment_metrics_barcode09.csv
    exit 0
fi

# Créer le dossier de sortie
mkdir -p output_barcode09

# Copier le fichier BAM avec un nom standard pour le script
cp "barcode09.sorted.bam" "barcode09.bam"

# Exécution du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode09.bam" \
    --output output_barcode09 \
    --sample "barcode09" || true

# Récupération du fichier CSV de sortie
CSV_FILE=$(find output_barcode09 -type f -name "*.csv" 2>/dev/null | head -n 1)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo "sample_id;status;note" > alignment_metrics_barcode09.csv
    echo "barcode09;vide;Aucune donnée analysable" >> alignment_metrics_barcode09.csv
else
    mv "$CSV_FILE" "alignment_metrics_barcode09.csv"
fi
