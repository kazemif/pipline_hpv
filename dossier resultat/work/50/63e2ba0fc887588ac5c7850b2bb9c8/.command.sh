#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode16"
mkdir -p output_barcode16

if [ ! -s barcode16_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode16_trim_reads.fastq.gz"
    exit 1
fi

gunzip -c barcode16_trim_reads.fastq.gz > barcode16_trimmed.fastq

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode16_trimmed.fastq \
    --output output_barcode16 \
    --sample barcode16

echo "📁 Fichiers générés :"
ls -lh output_barcode16

# Nettoyage du FASTQ décompressé
rm -f barcode16_trimmed.fastq
