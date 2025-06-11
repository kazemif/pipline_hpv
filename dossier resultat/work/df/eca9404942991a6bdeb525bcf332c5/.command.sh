#!/bin/bash -ue
echo "🔍 Traitement de : barcode13"
mkdir -p output_barcode13

# Vérifie si le fichier FASTQ est vide
if [ ! -s barcode13_trim_reads.fastq.gz ]; then
    echo "❌ Fichier vide : barcode13_trim_reads.fastq.gz"
    echo "Aucune donnée pour barcode13" > fastq_qc_barcode13.csv
    exit 0
fi

# Décompression
gunzip -c barcode13_trim_reads.fastq.gz > barcode13_trimmed.fastq

# Appel du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode13_trimmed.fastq \
    --output output_barcode13 \
    --sample barcode13

# Vérification si un fichier CSV a été généré
CSV_FILE=$(ls output_barcode13/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré, création d'un fichier vide"
    echo "Aucune donnée pour barcode13" > fastq_qc_barcode13.csv
else
    mv $CSV_FILE fastq_qc_barcode13.csv
fi
