#!/bin/bash -ue
echo "🔍 Traitement de barcode15"

# Aller chercher le SAM depuis le dossier des résultats
sam_file="./results/barcode15/barcode15.sam"

if [ ! -s "$sam_file" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode15.csv
    echo "barcode15;vide;Fichier SAM manquant ou vide" >> alignment_metrics_barcode15.csv
    exit 0
fi

# Créer le dossier pour résultats Python
mkdir -p output_barcode15

# Exécuter le script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    -i "$sam_file" \
    -o output_barcode15 \
    -s "barcode15" || true

# Vérifier si un CSV a été généré
CSV_FILE=$(ls output_barcode15/*.csv 2>/dev/null || true)
if [ -z "$CSV_FILE" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode15.csv
    echo "barcode15;vide;Aucune donnée analysable" >> alignment_metrics_barcode15.csv
else
    mv "$CSV_FILE" alignment_metrics_barcode15.csv
fi
