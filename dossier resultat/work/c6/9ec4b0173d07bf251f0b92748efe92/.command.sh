#!/bin/bash -ue
echo "🔍 Traitement de : barcode01"

if [ ! -s "barcode01.sorted.bam" ]; then
    echo "❌ Fichier vide ou inexistant : barcode01.sorted.bam"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode01.txt
    echo -e "barcode01\tvide\tFichier BAM vide" >> alignment_metrics_barcode01.txt
    exit 0
fi

mkdir -p output_barcode01

# 👉 Copier/renommer le BAM sans .sorted
cp "barcode01.sorted.bam" "barcode01.bam"

# Lancer le script Python sur le fichier renommé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode01.bam" \
    --output output_barcode01 \
    --sample "barcode01"

# Vérification du CSV
CSV_FILE=$(ls output_barcode01/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode01.txt
    echo -e "barcode01\tvide\tAucune donnée analysable" >> alignment_metrics_barcode01.txt
else
    mv "$CSV_FILE" "alignment_metrics_barcode01.csv"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode01.txt
    echo -e "barcode01\tsuccès\tFichier CSV généré" >> alignment_metrics_barcode01.txt
fi
