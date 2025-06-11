#!/bin/bash -ue
echo "🔍 Traitement de : barcode09"
mkdir -p output_barcode09

# Vérifie si le fichier FASTQ est vide
if [ ! -s barcode09_trim_reads.fastq.gz ]; then
    echo "❌ Fichier vide : barcode09_trim_reads.fastq.gz"
    echo "Aucune donnée pour barcode09" > fastq_qc_barcode09.csv
    exit 0
fi

# Décompression
gunzip -c barcode09_trim_reads.fastq.gz > barcode09_trimmed.fastq

# Appel du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode09_trimmed.fastq \
    --output output_barcode09 \
    --sample barcode09

# Vérification si un fichier CSV a été généré
CSV_FILE=$(ls output_barcode09/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré, création d'un fichier vide"
    echo "Aucune donnée pour barcode09" > fastq_qc_barcode09.csv
else
    mv $CSV_FILE fastq_qc_barcode09.csv
fi
