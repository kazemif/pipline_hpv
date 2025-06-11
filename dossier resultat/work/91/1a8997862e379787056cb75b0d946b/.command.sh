#!/bin/bash -ue
echo "🔍 Analyse de barcode11"

mkdir -p output_barcode11

# Lancer le script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py         -i "barcode11.sam"         -o output_barcode11         -s "barcode11" || true

# Vérifier et déplacer le résultat
CSV_FILE=$(find output_barcode11 -name "*.csv" | head -n 1)

if [ ! -f "$CSV_FILE" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode11.csv
    echo "barcode11;vide;Fichier SAM manquant ou vide" >> alignment_metrics_barcode11.csv
else
    mv "$CSV_FILE" alignment_metrics_barcode11.csv
fi
