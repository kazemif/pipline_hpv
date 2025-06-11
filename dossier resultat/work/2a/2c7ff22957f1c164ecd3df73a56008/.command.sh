#!/bin/bash -ue
echo "🔍 Traitement de : barcode06"

# Vérifie si le fichier BAM est vide
if [ ! -s "barcode06.sorted.bam" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode06.csv
    echo "barcode06;vide;Fichier BAM vide" >> alignment_metrics_barcode06.csv
    exit 0
fi

# Créer le dossier de sortie
mkdir -p output_barcode06

# Copier le fichier BAM avec un nom standard pour le script
cp "barcode06.sorted.bam" "barcode06.bam"

# Exécution du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode06.bam" \
    --output output_barcode06 \
    --sample "barcode06" || true

# Récupération du fichier CSV de sortie
CSV_FILE=$(find output_barcode06 -type f -name "*.csv" 2>/dev/null | head -n 1)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo "sample_id;status;note" > alignment_metrics_barcode06.csv
    echo "barcode06;vide;Aucune donnée analysable" >> alignment_metrics_barcode06.csv
else
    mv "$CSV_FILE" "alignment_metrics_barcode06.csv"
fi
