#!/bin/bash -ue
echo "🔍 Analyse de barcode12"

mkdir -p output_barcode12

# Lancer le script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py         -i "barcode12.sam"         -o output_barcode12         -s "barcode12" || true

# Vérifier et déplacer le résultat
CSV_FILE=$(find output_barcode12 -name "*.csv" | head -n 1)

if [ ! -f "$CSV_FILE" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode12.csv
    echo "barcode12;vide;Fichier SAM manquant ou vide" >> alignment_metrics_barcode12.csv
else
    mv "$CSV_FILE" alignment_metrics_barcode12.csv
fi
