#!/bin/bash -ue
echo "🔍 Analyse de barcode14"

mkdir -p output_barcode14

# Lancer le script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py         -i "barcode14.sam"         -o output_barcode14         -s "barcode14" || true

# Vérifier et déplacer le résultat
CSV_FILE=$(find output_barcode14 -name "*.csv" | head -n 1)

if [ ! -f "$CSV_FILE" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode14.csv
    echo "barcode14;vide;Fichier SAM manquant ou vide" >> alignment_metrics_barcode14.csv
else
    mv "$CSV_FILE" alignment_metrics_barcode14.csv
fi
