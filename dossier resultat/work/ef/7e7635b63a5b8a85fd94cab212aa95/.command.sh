#!/bin/bash -ue
echo "🔍 Traitement de : barcode05"

if [ ! -s "barcode05.sorted.bam" ]; then
    echo "❌ Fichier vide ou inexistant : barcode05.sorted.bam"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode05.txt
    echo -e "barcode05\tvide\tFichier BAM vide" >> alignment_metrics_barcode05.txt
    exit 0
fi

mkdir -p output_barcode05

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode05.sorted.bam" \
    --output output_barcode05 \
    --sample "barcode05"

CSV_FILE=$(ls output_barcode05/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode05.txt
    echo -e "barcode05\tvide\tAucune donnée analysable" >> alignment_metrics_barcode05.txt
else
    mv "$CSV_FILE" "alignment_metrics_barcode05.csv"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode05.txt
    echo -e "barcode05\tsuccès\tFichier CSV généré" >> alignment_metrics_barcode05.txt
fi
