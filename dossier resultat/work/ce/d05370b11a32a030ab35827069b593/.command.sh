#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode02"
mkdir -p output_barcode02

# Vérifie que le fichier FASTQ compressé existe
if [ ! -s barcode02_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode02_trim_reads.fastq.gz"
    exit 1
fi

# Décompression du fichier FASTQ
gunzip -c barcode02_trim_reads.fastq.gz > barcode02_trimmed.fastq

# Exécution du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode02_trimmed.fastq \
    --output output_barcode02 \
    --sample barcode02

echo "📁 Fichiers générés :"
ls -lh output_barcode02

# Création d’une archive contenant tous les fichiers de sortie
tar -czf fastq_qc_barcode02.tar.gz -C output_barcode02 .

# Nettoyage temporaire
rm -f barcode02_trimmed.fastq
