#!/bin/bash -ue
echo "🔍 Traitement de : barcode07"

if [ ! -s "barcode07.sorted.bam" ]; then
    echo "❌ Fichier vide ou inexistant : barcode07.sorted.bam"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode07.txt
    echo -e "barcode07\tvide\tFichier BAM vide" >> alignment_metrics_barcode07.txt
    exit 0
fi

mkdir -p output_barcode07

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode07.sorted.bam" \
    --output output_barcode07 \
    --sample "barcode07"

CSV_FILE=$(ls output_barcode07/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode07.txt
    echo -e "barcode07\tvide\tAucune donnée analysable" >> alignment_metrics_barcode07.txt
else
    mv "$CSV_FILE" "alignment_metrics_barcode07.csv"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode07.txt
    echo -e "barcode07\tsuccès\tFichier CSV généré" >> alignment_metrics_barcode07.txt
fi
