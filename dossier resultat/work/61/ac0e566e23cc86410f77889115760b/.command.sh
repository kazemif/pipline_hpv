#!/bin/bash -ue
echo "🔍 Traitement de barcode07"

# Aller chercher le SAM depuis le dossier des résultats
sam_file="./results/barcode07/barcode07.sam"

if [ ! -s "$sam_file" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode07.csv
    echo "barcode07;vide;Fichier SAM manquant ou vide" >> alignment_metrics_barcode07.csv
    exit 0
fi

# Créer le dossier pour résultats Python
mkdir -p output_barcode07

# Exécuter le script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    -i "$sam_file" \
    -o output_barcode07 \
    -s "barcode07" || true

# Vérifier si un CSV a été généré
CSV_FILE=$(ls output_barcode07/*.csv 2>/dev/null || true)
if [ -z "$CSV_FILE" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode07.csv
    echo "barcode07;vide;Aucune donnée analysable" >> alignment_metrics_barcode07.csv
else
    mv "$CSV_FILE" alignment_metrics_barcode07.csv
fi
