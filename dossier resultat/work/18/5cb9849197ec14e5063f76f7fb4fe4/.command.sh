#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode04"
mkdir -p output_barcode04

if [ ! -s barcode04_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode04_trim_reads.fastq.gz"
    exit 1
fi

gunzip -c barcode04_trim_reads.fastq.gz > barcode04_trimmed.fastq

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py         --input barcode04_trimmed.fastq         --output output_barcode04         --sample barcode04

echo "📁 Fichiers générés :"
ls -lh output_barcode04

# (Plus d’archive ici)
rm -f barcode04_trimmed.fastq
