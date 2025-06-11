#!/bin/bash -ue
echo "🔍 Traitement de : barcode03"

if [ ! -s "barcode03.sorted.bam" ]; then
    echo "❌ Fichier vide ou inexistant : barcode03.sorted.bam"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode03.txt
    echo -e "barcode03\tvide\tFichier BAM vide" >> alignment_metrics_barcode03.txt
    exit 0
fi

mkdir -p output_barcode03

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode03.sorted.bam" \
    --output output_barcode03 \
    --sample "barcode03"

CSV_FILE=$(ls output_barcode03/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode03.txt
    echo -e "barcode03\tvide\tAucune donnée analysable" >> alignment_metrics_barcode03.txt
else
    mv "$CSV_FILE" "alignment_metrics_barcode03.csv"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode03.txt
    echo -e "barcode03\tsuccès\tFichier CSV généré" >> alignment_metrics_barcode03.txt
fi
