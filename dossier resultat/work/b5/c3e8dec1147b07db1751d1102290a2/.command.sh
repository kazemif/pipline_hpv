#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode04"
mkdir -p output_barcode04

# Vérifie que le fichier FASTQ compressé existe
if [ ! -s barcode04_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode04_trim_reads.fastq.gz"
    exit 1
fi

# Décompression du fichier FASTQ
gunzip -c barcode04_trim_reads.fastq.gz > barcode04_trimmed.fastq

# Exécution du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode04_trimmed.fastq \
    --output output_barcode04 \
    --sample barcode04

echo "📁 Fichiers générés :"
ls -lh output_barcode04

# Création d’une archive contenant tous les fichiers de sortie
tar -czf fastq_qc_barcode04.tar.gz -C output_barcode04 .

# Nettoyage temporaire
rm -f barcode04_trimmed.fastq
