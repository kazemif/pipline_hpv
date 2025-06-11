#!/bin/bash -ue
echo "🔍 Analyse de barcode09"

mkdir -p output_barcode09

# Lancer le script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py         -i "barcode09.sam"         -o output_barcode09         -s "barcode09" || true

# Vérifier et déplacer le résultat
CSV_FILE=$(find output_barcode09 -name "*.csv" | head -n 1)

if [ ! -f "$CSV_FILE" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode09.csv
    echo "barcode09;vide;Fichier SAM manquant ou vide" >> alignment_metrics_barcode09.csv
else
    mv "$CSV_FILE" alignment_metrics_barcode09.csv
fi
