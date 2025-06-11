#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode08"
mkdir -p output_barcode08

if [ ! -s barcode08_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode08_trim_reads.fastq.gz"
    exit 1
fi

gunzip -c barcode08_trim_reads.fastq.gz > barcode08_trimmed.fastq

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py         --input barcode08_trimmed.fastq         --output output_barcode08         --sample barcode08

echo "📁 Fichiers générés :"
ls -lh output_barcode08

# (Plus d’archive ici)
rm -f barcode08_trimmed.fastq
