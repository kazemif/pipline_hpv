#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode07"
mkdir -p output_barcode07

if [ ! -s barcode07_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode07_trim_reads.fastq.gz"
    exit 1
fi

gunzip -c barcode07_trim_reads.fastq.gz > barcode07_trimmed.fastq

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py         --input barcode07_trimmed.fastq         --output output_barcode07         --sample barcode07

echo "📁 Fichiers générés :"
ls -lh output_barcode07

# (Plus d’archive ici)
rm -f barcode07_trimmed.fastq
