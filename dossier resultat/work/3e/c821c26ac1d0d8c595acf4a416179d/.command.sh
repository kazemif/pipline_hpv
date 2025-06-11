#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode13"
mkdir -p output_barcode13

# Vérifie que le fichier FASTQ compressé existe
if [ ! -s barcode13_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode13_trim_reads.fastq.gz"
    exit 1
fi

# Décompression du fichier FASTQ
gunzip -c barcode13_trim_reads.fastq.gz > barcode13_trimmed.fastq

# Exécution du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode13_trimmed.fastq \
    --output output_barcode13 \
    --sample barcode13

echo "📁 Fichiers générés :"
ls -lh output_barcode13

# Création d’une archive contenant tous les fichiers de sortie
tar -czf fastq_qc_barcode13.tar.gz -C output_barcode13 .

# Nettoyage temporaire
rm -f barcode13_trimmed.fastq
