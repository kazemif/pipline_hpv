#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode12"
mkdir -p output_barcode12

if [ ! -s barcode12_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode12_trim_reads.fastq.gz"
    exit 1
fi

gunzip -c barcode12_trim_reads.fastq.gz > barcode12_trimmed.fastq

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode12_trimmed.fastq \
    --output output_barcode12 \
    --sample barcode12

echo "📁 Fichiers générés :"
ls -lh output_barcode12

# Nettoyage du FASTQ décompressé
rm -f barcode12_trimmed.fastq
