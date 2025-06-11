#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode02"
mkdir -p output_barcode02

if [ ! -s barcode02_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode02_trim_reads.fastq.gz"
    exit 1
fi

gunzip -c barcode02_trim_reads.fastq.gz > barcode02_trimmed.fastq

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode02_trimmed.fastq \
    --output output_barcode02 \
    --sample barcode02

echo "📁 Contenu du dossier de sortie :"
ls -l output_barcode02

CSV_FILE=$(ls output_barcode02/*.{csv,tsv,txt} 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "❌ Aucun fichier CSV généré dans output_barcode02"
    exit 1
fi

mv $CSV_FILE fastq_qc_barcode02.stat.tsv
rm -f barcode02_trimmed.fastq
