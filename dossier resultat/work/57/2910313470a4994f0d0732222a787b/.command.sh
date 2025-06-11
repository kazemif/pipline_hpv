#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode06"
mkdir -p output_barcode06

# Vérifie que le fichier FASTQ compressé existe
if [ ! -s barcode06_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode06_trim_reads.fastq.gz"
    exit 1
fi

# Décompression du fichier FASTQ
gunzip -c barcode06_trim_reads.fastq.gz > barcode06_trimmed.fastq

# Exécution du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode06_trimmed.fastq \
    --output output_barcode06 \
    --sample barcode06

echo "📁 Fichiers générés :"
ls -lh output_barcode06

# Création d’une archive contenant tous les fichiers de sortie
tar -czf fastq_qc_barcode06.tar.gz -C output_barcode06 .

# Nettoyage temporaire
rm -f barcode06_trimmed.fastq
