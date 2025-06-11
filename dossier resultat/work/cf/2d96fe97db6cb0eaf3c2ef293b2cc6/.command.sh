#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode03"
mkdir -p output_barcode03

if [ ! -s barcode03_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode03_trim_reads.fastq.gz"
    exit 1
fi

gunzip -c barcode03_trim_reads.fastq.gz > barcode03_trimmed.fastq

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode03_trimmed.fastq \
    --output output_barcode03 \
    --sample barcode03

CSV_FILE=$(ls output_barcode03/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "❌ Aucun fichier CSV généré dans output_barcode03"
    exit 1
fi

mv $CSV_FILE fastq_qc_barcode03.stat.tsv
rm -f barcode03_trimmed.fastq
