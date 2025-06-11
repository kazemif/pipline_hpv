#!/bin/bash -ue
echo "🔍 Traitement de : barcode11"

if [ ! -s "barcode11.sorted.bam" ]; then
    echo "❌ Fichier vide ou inexistant : barcode11.sorted.bam"
    echo "sample_id,status,note" > alignment_metrics_barcode11.csv
    echo "barcode11,vide,Fichier BAM vide" >> alignment_metrics_barcode11.csv
    exit 0
fi

mkdir -p output_barcode11

# 👉 Copier/renommer le BAM sans .sorted
cp "barcode11.sorted.bam" "barcode11.bam"

# Lancer le script Python sur le fichier renommé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode11.bam" \
    --output output_barcode11 \
    --sample "barcode11"

# Vérification du CSV
CSV_FILE=$(ls output_barcode11/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo "sample_id,status,note" > alignment_metrics_barcode11.csv
    echo "barcode11,vide,Aucune donnée analysable" >> alignment_metrics_barcode11.csv
else
    mv "$CSV_FILE" "alignment_metrics_barcode11.csv"
fi
