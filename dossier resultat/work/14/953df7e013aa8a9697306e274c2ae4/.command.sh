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

echo "📁 Contenu du dossier de sortie :"
ls -l output_barcode13

CSV_FILE=$(ls output_barcode13/*.{csv,tsv,txt} 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "❌ Aucun fichier CSV généré dans output_barcode13"
    exit 1
fi

mv $CSV_FILE fastq_qc_barcode13.stat.tsv
rm -f barcode13_trimmed.fastq
