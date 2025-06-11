#!/bin/bash -ue
echo "🔍 Traitement de : barcode01"
mkdir -p output_barcode01

# Vérifie si le fichier FASTQ est vide
if [ ! -s barcode01_trim_reads.fastq.gz ]; then
    echo "❌ Fichier vide : barcode01_trim_reads.fastq.gz"
    echo "Aucune donnée pour barcode01" > fastq_qc_barcode01.csv
    exit 0
fi

# Décompression
gunzip -c barcode01_trim_reads.fastq.gz > barcode01_trimmed.fastq

# Appel du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode01_trimmed.fastq \
    --output output_barcode01 \
    --sample barcode01

# Vérification si un fichier CSV a été généré
CSV_FILE=$(ls output_barcode01/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré, création d'un fichier vide"
    echo "Aucune donnée pour barcode01" > fastq_qc_barcode01.csv
else
    mv $CSV_FILE fastq_qc_barcode01.csv
fi
