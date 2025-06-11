#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode14"
mkdir -p output_barcode14

if [ ! -s barcode14_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode14_trim_reads.fastq.gz"
    exit 1
fi

gunzip -c barcode14_trim_reads.fastq.gz > barcode14_trimmed.fastq

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode14_trimmed.fastq \
    --output output_barcode14 \
    --sample barcode14

echo "📁 Fichiers générés :"
ls -lh output_barcode14

# Nettoyage du FASTQ décompressé
rm -f barcode14_trimmed.fastq
