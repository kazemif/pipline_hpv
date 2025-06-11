#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode02"
mkdir -p output_barcode02

if [ ! -s barcode02_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode02_trim_reads.fastq.gz"
    exit 1
fi

gunzip -c barcode02_trim_reads.fastq.gz > barcode02_trimmed.fastq

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py         --input barcode02_trimmed.fastq         --output output_barcode02         --sample barcode02

echo "📁 Fichiers générés :"
ls -lh output_barcode02

# (Plus d’archive ici)
rm -f barcode02_trimmed.fastq
