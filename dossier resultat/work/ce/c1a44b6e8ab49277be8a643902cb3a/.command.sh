#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode07"
mkdir -p output_barcode07

if [ ! -s barcode07_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode07_trim_reads.fastq.gz"
    exit 1
fi

gunzip -c barcode07_trim_reads.fastq.gz > barcode07_trimmed.fastq

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode07_trimmed.fastq \
    --output output_barcode07 \
    --sample barcode07

CSV_FILE=$(ls output_barcode07/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "❌ Aucun fichier CSV généré dans output_barcode07"
    exit 1
fi

mv $CSV_FILE fastq_qc_barcode07.stat.tsv
rm -f barcode07_trimmed.fastq
