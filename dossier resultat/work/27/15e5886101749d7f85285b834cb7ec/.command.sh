#!/bin/bash -ue
echo "🔍 Traitement de : barcode15"

if [ ! -s "barcode15.sorted.bam" ]; then
    echo "❌ Fichier vide ou inexistant : barcode15.sorted.bam"
    echo "sample_id,status,note" > alignment_metrics_barcode15.csv
    echo "barcode15,vide,Fichier BAM vide" >> alignment_metrics_barcode15.csv
    exit 0
fi

mkdir -p output_barcode15

# 👉 Copier/renommer le BAM sans .sorted
cp "barcode15.sorted.bam" "barcode15.bam"

# Lancer le script Python sur le fichier renommé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode15.bam" \
    --output output_barcode15 \
    --sample "barcode15"

# Vérification du CSV
CSV_FILE=$(ls output_barcode15/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo "sample_id,status,note" > alignment_metrics_barcode15.csv
    echo "barcode15,vide,Aucune donnée analysable" >> alignment_metrics_barcode15.csv
else
    mv "$CSV_FILE" "alignment_metrics_barcode15.csv"
fi
