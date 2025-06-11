#!/bin/bash -ue
echo "🔍 Traitement de : barcode09"

if [ ! -s "barcode09.sorted.bam" ]; then
    echo "❌ Fichier vide ou inexistant : barcode09.sorted.bam"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode09.txt
    echo -e "barcode09\tvide\tFichier BAM vide" >> alignment_metrics_barcode09.txt
    exit 0
fi

mkdir -p output_barcode09

# 👉 Copier/renommer le BAM sans .sorted
cp "barcode09.sorted.bam" "barcode09.bam"

# Lancer le script Python sur le fichier renommé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode09.bam" \
    --output output_barcode09 \
    --sample "barcode09"

# Vérification du CSV
CSV_FILE=$(ls output_barcode09/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode09.txt
    echo -e "barcode09\tvide\tAucune donnée analysable" >> alignment_metrics_barcode09.txt
else
    mv "$CSV_FILE" "alignment_metrics_barcode09.csv"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode09.txt
    echo -e "barcode09\tsuccès\tFichier CSV généré" >> alignment_metrics_barcode09.txt
fi
