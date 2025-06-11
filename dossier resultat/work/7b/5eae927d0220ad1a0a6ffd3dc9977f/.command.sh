#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode05"
mkdir -p output_barcode05

if [ ! -s barcode05_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode05_trim_reads.fastq.gz"
    exit 1
fi

gunzip -c barcode05_trim_reads.fastq.gz > barcode05_trimmed.fastq

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode05_trimmed.fastq \
    --output output_barcode05 \
    --sample barcode05

CSV_FILE=$(ls output_barcode05/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "❌ Aucun fichier CSV généré dans output_barcode05"
    exit 1
fi

mv $CSV_FILE fastq_qc_barcode05.stat.tsv
rm -f barcode05_trimmed.fastq
