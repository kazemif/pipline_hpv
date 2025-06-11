#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode05"
mkdir -p output_barcode05

# Vérifie que le fichier FASTQ compressé existe
if [ ! -s barcode05_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode05_trim_reads.fastq.gz"
    exit 1
fi

# Décompression du fichier FASTQ
gunzip -c barcode05_trim_reads.fastq.gz > barcode05_trimmed.fastq

# Exécution du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode05_trimmed.fastq \
    --output output_barcode05 \
    --sample barcode05

echo "📁 Fichiers générés :"
ls -lh output_barcode05

# Création d’une archive contenant tous les fichiers de sortie
tar -czf fastq_qc_barcode05.tar.gz -C output_barcode05 .

# Nettoyage temporaire
rm -f barcode05_trimmed.fastq
