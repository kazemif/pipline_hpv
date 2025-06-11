#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode09"
mkdir -p output_barcode09

# Vérifie que le fichier FASTQ compressé existe
if [ ! -s barcode09_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode09_trim_reads.fastq.gz"
    exit 1
fi

# Décompression du fichier FASTQ
gunzip -c barcode09_trim_reads.fastq.gz > barcode09_trimmed.fastq

# Exécution du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode09_trimmed.fastq \
    --output output_barcode09 \
    --sample barcode09

echo "📁 Fichiers générés :"
ls -lh output_barcode09

# Création d’une archive contenant tous les fichiers de sortie
tar -czf fastq_qc_barcode09.tar.gz -C output_barcode09 .

# Nettoyage temporaire
rm -f barcode09_trimmed.fastq
