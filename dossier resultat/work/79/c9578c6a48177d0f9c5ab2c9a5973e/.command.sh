#!/bin/bash -ue
echo "🔍 Analyse de barcode08"

mkdir -p output_barcode08

# Lancer le script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py         -i "barcode08.sam"         -o output_barcode08         -s "barcode08" || true

# Vérifier et déplacer le résultat
CSV_FILE=$(find output_barcode08 -name "*.csv" | head -n 1)

if [ ! -f "$CSV_FILE" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode08.csv
    echo "barcode08;vide;Fichier SAM manquant ou vide" >> alignment_metrics_barcode08.csv
else
    mv "$CSV_FILE" alignment_metrics_barcode08.csv
fi
