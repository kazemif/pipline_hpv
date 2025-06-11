#!/bin/bash -ue
echo "🔍 Traitement de : barcode11"
mkdir -p output_barcode11

# Vérifie si le fichier FASTQ est vide
if [ ! -s barcode11_trim_reads.fastq.gz ]; then
    echo "❌ Fichier vide : barcode11_trim_reads.fastq.gz"
    echo "Aucune donnée pour barcode11" > fastq_qc_barcode11.csv
    exit 0
fi

# Décompression
gunzip -c barcode11_trim_reads.fastq.gz > barcode11_trimmed.fastq

# Appel du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode11_trimmed.fastq \
    --output output_barcode11 \
    --sample barcode11

# Vérification si un fichier CSV a été généré
CSV_FILE=$(ls output_barcode11/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré, création d'un fichier vide"
    echo "Aucune donnée pour barcode11" > fastq_qc_barcode11.csv
else
    mv $CSV_FILE fastq_qc_barcode11.csv
fi
