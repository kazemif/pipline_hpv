#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode15"
mkdir -p output_barcode15

if [ ! -s barcode15_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode15_trim_reads.fastq.gz"
    exit 1
fi

gunzip -c barcode15_trim_reads.fastq.gz > barcode15_trimmed.fastq

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode15_trimmed.fastq \
    --output output_barcode15 \
    --sample barcode15

echo "📁 Fichiers générés :"
ls -lh output_barcode15

# Nettoyage du FASTQ décompressé
rm -f barcode15_trimmed.fastq
