#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode05"
mkdir -p output_barcode05

if [ ! -s barcode05_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode05_trim_reads.fastq.gz"
    exit 1
fi

gunzip -c barcode05_trim_reads.fastq.gz > barcode05_trimmed.fastq

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py         --input barcode05_trimmed.fastq         --output output_barcode05         --sample barcode05

echo "📁 Fichiers générés :"
ls -lh output_barcode05

# (Plus d’archive ici)
rm -f barcode05_trimmed.fastq
