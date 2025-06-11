#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode11"
mkdir -p output_barcode11

if [ ! -s barcode11_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode11_trim_reads.fastq.gz"
    exit 1
fi

gunzip -c barcode11_trim_reads.fastq.gz > barcode11_trimmed.fastq

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py         --input barcode11_trimmed.fastq         --output output_barcode11         --sample barcode11

echo "📁 Fichiers générés :"
ls -lh output_barcode11

# (Plus d’archive ici)
rm -f barcode11_trimmed.fastq
