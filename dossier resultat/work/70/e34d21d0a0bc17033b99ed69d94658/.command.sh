#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode10"
mkdir -p output_barcode10

# Vérifie que le fichier FASTQ compressé existe
if [ ! -s barcode10_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode10_trim_reads.fastq.gz"
    exit 1
fi

# Décompression du fichier FASTQ
gunzip -c barcode10_trim_reads.fastq.gz > barcode10_trimmed.fastq

# Exécution du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode10_trimmed.fastq \
    --output output_barcode10 \
    --sample barcode10

echo "📁 Fichiers générés :"
ls -lh output_barcode10

# Création d’une archive contenant tous les fichiers de sortie
tar -czf fastq_qc_barcode10.tar.gz -C output_barcode10 .

# Nettoyage temporaire
rm -f barcode10_trimmed.fastq
