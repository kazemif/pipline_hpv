#!/bin/bash -ue
echo "🔍 Traitement de : barcode07"

if [ ! -s "barcode07.sorted.bam" ]; then
    echo "❌ Fichier vide ou inexistant : barcode07.sorted.bam"
    echo "sample_id,status,note" > alignment_metrics_barcode07.csv
    echo "barcode07,vide,Fichier BAM vide" >> alignment_metrics_barcode07.csv
    exit 0
fi

mkdir -p output_barcode07

# 👉 Copier/renommer le BAM sans .sorted
cp "barcode07.sorted.bam" "barcode07.bam"

# Lancer le script Python sur le fichier renommé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode07.bam" \
    --output output_barcode07 \
    --sample "barcode07"

# Vérification du CSV
CSV_FILE=$(ls output_barcode07/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo "sample_id,status,note" > alignment_metrics_barcode07.csv
    echo "barcode07,vide,Aucune donnée analysable" >> alignment_metrics_barcode07.csv
else
    mv "$CSV_FILE" "alignment_metrics_barcode07.csv"
fi
