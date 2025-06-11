#!/bin/bash -ue
echo "🔍 Traitement de : barcode12"
mkdir -p output_barcode12

# Vérifie si le fichier FASTQ est vide
if [ ! -s barcode12_trim_reads.fastq.gz ]; then
    echo "❌ Fichier vide : barcode12_trim_reads.fastq.gz"
    echo "Aucune donnée pour barcode12" > fastq_qc_barcode12.csv
    exit 0
fi

# Décompression
gunzip -c barcode12_trim_reads.fastq.gz > barcode12_trimmed.fastq

# Appel du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode12_trimmed.fastq \
    --output output_barcode12 \
    --sample barcode12

# Vérification si un fichier CSV a été généré
CSV_FILE=$(ls output_barcode12/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré, création d'un fichier vide"
    echo "Aucune donnée pour barcode12" > fastq_qc_barcode12.csv
else
    mv $CSV_FILE fastq_qc_barcode12.csv
fi
