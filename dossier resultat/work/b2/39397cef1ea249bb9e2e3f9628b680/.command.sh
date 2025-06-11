#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode15"
mkdir -p output_barcode15

# Vérifie que le fichier FASTQ compressé existe
if [ ! -s barcode15_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode15_trim_reads.fastq.gz"
    exit 1
fi

# Décompression du fichier FASTQ
gunzip -c barcode15_trim_reads.fastq.gz > barcode15_trimmed.fastq

# Exécution du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode15_trimmed.fastq \
    --output output_barcode15 \
    --sample barcode15

echo "📁 Fichiers générés :"
ls -lh output_barcode15

# Création d’une archive contenant tous les fichiers de sortie
tar -czf fastq_qc_barcode15.tar.gz -C output_barcode15 .

# Nettoyage temporaire
rm -f barcode15_trimmed.fastq
