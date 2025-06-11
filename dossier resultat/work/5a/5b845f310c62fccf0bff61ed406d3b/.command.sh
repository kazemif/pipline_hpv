#!/bin/bash -ue
echo "🔍 Traitement de : barcode03"

# Vérifie si le fichier BAM est vide
if [ ! -s "barcode03.sorted.bam" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode03.csv
    echo "barcode03;vide;Fichier BAM vide" >> alignment_metrics_barcode03.csv
    exit 0
fi

# Créer le dossier de sortie
mkdir -p output_barcode03

# Copier le fichier BAM avec un nom standard pour le script
cp "barcode03.sorted.bam" "barcode03.bam"

# Exécution du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode03.bam" \
    --output output_barcode03 \
    --sample "barcode03" || true

# Récupération du fichier CSV de sortie
CSV_FILE=$(find output_barcode03 -type f -name "*.csv" 2>/dev/null | head -n 1)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo "sample_id;status;note" > alignment_metrics_barcode03.csv
    echo "barcode03;vide;Aucune donnée analysable" >> alignment_metrics_barcode03.csv
else
    mv "$CSV_FILE" "alignment_metrics_barcode03.csv"
fi
