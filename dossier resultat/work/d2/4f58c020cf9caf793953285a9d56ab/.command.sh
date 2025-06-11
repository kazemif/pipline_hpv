#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode06"
mkdir -p output_barcode06

if [ ! -s barcode06_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode06_trim_reads.fastq.gz"
    exit 1
fi

gunzip -c barcode06_trim_reads.fastq.gz > barcode06_trimmed.fastq

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py         --input barcode06_trimmed.fastq         --output output_barcode06         --sample barcode06

echo "📁 Fichiers générés :"
ls -lh output_barcode06

# (Plus d’archive ici)
rm -f barcode06_trimmed.fastq
