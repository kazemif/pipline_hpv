#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode16"
mkdir -p output_barcode16

# Vérifie que le fichier FASTQ compressé existe
if [ ! -s barcode16_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode16_trim_reads.fastq.gz"
    exit 1
fi

# Décompression du fichier FASTQ
gunzip -c barcode16_trim_reads.fastq.gz > barcode16_trimmed.fastq

# Exécution du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode16_trimmed.fastq \
    --output output_barcode16 \
    --sample barcode16

echo "📁 Fichiers générés :"
ls -lh output_barcode16

# ✅ Création d’un fichier ZIP avec tous les fichiers de sortie
zip -j fastq_qc_barcode16.zip output_barcode16/*.txt

# Nettoyage temporaire
rm -f barcode16_trimmed.fastq
