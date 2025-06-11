#!/bin/bash -ue
echo "🔍 Analyse de barcode01"

mkdir -p output_barcode01

# Lancer le script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py         -i "barcode01.sam"         -o output_barcode01         -s "barcode01" || true

# Vérifier et déplacer le résultat
CSV_FILE=$(find output_barcode01 -name "*.csv" | head -n 1)

if [ ! -f "$CSV_FILE" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode01.csv
    echo "barcode01;vide;Fichier SAM manquant ou vide" >> alignment_metrics_barcode01.csv
else
    mv "$CSV_FILE" alignment_metrics_barcode01.csv
fi
