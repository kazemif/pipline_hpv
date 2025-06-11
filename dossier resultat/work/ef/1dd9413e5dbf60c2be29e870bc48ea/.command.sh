#!/bin/bash -ue
echo "🔍 Traitement de : barcode12"

# Vérifie si le fichier BAM est vide
if [ ! -s "barcode12.sorted.bam" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode12.csv
    echo "barcode12;vide;Fichier BAM vide" >> alignment_metrics_barcode12.csv
    exit 0
fi

# Créer le dossier de sortie
mkdir -p output_barcode12

# Copier le fichier BAM avec un nom standard pour le script
cp "barcode12.sorted.bam" "barcode12.bam"

# Exécution du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode12.bam" \
    --output output_barcode12 \
    --sample "barcode12" || true

# Récupération du fichier CSV de sortie
CSV_FILE=$(find output_barcode12 -type f -name "*.csv" 2>/dev/null | head -n 1)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo "sample_id;status;note" > alignment_metrics_barcode12.csv
    echo "barcode12;vide;Aucune donnée analysable" >> alignment_metrics_barcode12.csv
else
    mv "$CSV_FILE" "alignment_metrics_barcode12.csv"
fi
