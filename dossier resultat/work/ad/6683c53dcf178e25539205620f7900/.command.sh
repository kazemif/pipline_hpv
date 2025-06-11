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

# ✅ Création d’un fichier ZIP avec tous les fichiers de sortie
zip -j fastq_qc_barcode02.zip output_barcode02/*.txt

# Nettoyage temporaire
rm -f barcode02_trimmed.fastq
