#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode12"
mkdir -p output_barcode12

if [ ! -s barcode12_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode12_trim_reads.fastq.gz"
    exit 1
fi

gunzip -c barcode12_trim_reads.fastq.gz > barcode12_trimmed.fastq

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode12_trimmed.fastq \
    --output output_barcode12 \
    --sample barcode12

CSV_FILE=$(ls output_barcode12/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "❌ Aucun fichier CSV généré dans output_barcode12"
    exit 1
fi

mv $CSV_FILE fastq_qc_barcode12.stat.tsv
rm -f barcode12_trimmed.fastq
