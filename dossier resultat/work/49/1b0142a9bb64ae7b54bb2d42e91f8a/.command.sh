#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode13"
mkdir -p output_barcode13

if [ ! -s barcode13_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode13_trim_reads.fastq.gz"
    exit 1
fi

gunzip -c barcode13_trim_reads.fastq.gz > barcode13_trimmed.fastq

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode13_trimmed.fastq \
    --output output_barcode13 \
    --sample barcode13

echo "📁 Fichiers générés :"
ls -lh output_barcode13

# Nettoyage du FASTQ décompressé
rm -f barcode13_trimmed.fastq
