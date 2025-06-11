#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode01"
mkdir -p output_barcode01

if [ ! -s barcode01_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode01_trim_reads.fastq.gz"
    exit 1
fi

gunzip -c barcode01_trim_reads.fastq.gz > barcode01_trimmed.fastq

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py         --input barcode01_trimmed.fastq         --output output_barcode01         --sample barcode01

echo "📁 Fichiers générés :"
ls -lh output_barcode01

# (Plus d’archive ici)
rm -f barcode01_trimmed.fastq
