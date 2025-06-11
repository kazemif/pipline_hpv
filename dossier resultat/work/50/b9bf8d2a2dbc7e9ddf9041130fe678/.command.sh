#!/bin/bash -ue
echo "🔍 Traitement de : barcode13"
mkdir -p output_barcode13

# Vérification si le fichier est lisible
if [ ! -s barcode13_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode13_trim_reads.fastq.gz"
    exit 1
fi

# Décompression du fichier .fastq.gz vers un fichier temporaire
gunzip -c barcode13_trim_reads.fastq.gz > barcode13_trimmed.fastq

if [ $? -ne 0 ]; then
    echo "❌ Erreur lors de la décompression : barcode13_trim_reads.fastq.gz"
    exit 1
fi

# Appel du script Python avec le fichier FASTQ décompressé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode13_trimmed.fastq \
    --output output_barcode13 \
    --sample barcode13

# Vérification si un fichier CSV a été généré
CSV_FILE=$(ls output_barcode13/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "❌ Aucun fichier CSV généré dans output_barcode13"
    exit 1
fi

# Renommage du fichier CSV
mv $CSV_FILE fastq_qc_barcode13.csv
