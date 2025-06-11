#!/bin/bash -ue
echo "🔍 Traitement de barcode16"

# Aller chercher le SAM depuis le dossier des résultats
sam_file="./results/barcode16/barcode16.sam"

if [ ! -s "$sam_file" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode16.csv
    echo "barcode16;vide;Fichier SAM manquant ou vide" >> alignment_metrics_barcode16.csv
    exit 0
fi

# Créer le dossier pour résultats Python
mkdir -p output_barcode16

# Exécuter le script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    -i "$sam_file" \
    -o output_barcode16 \
    -s "barcode16" || true

# Vérifier si un CSV a été généré
CSV_FILE=$(ls output_barcode16/*.csv 2>/dev/null || true)
if [ -z "$CSV_FILE" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode16.csv
    echo "barcode16;vide;Aucune donnée analysable" >> alignment_metrics_barcode16.csv
else
    mv "$CSV_FILE" alignment_metrics_barcode16.csv
fi
