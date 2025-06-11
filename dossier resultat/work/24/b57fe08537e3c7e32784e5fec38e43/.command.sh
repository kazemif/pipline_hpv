#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode12"
mkdir -p output_barcode12

# Vérifie que le fichier FASTQ compressé existe
if [ ! -s barcode12_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode12_trim_reads.fastq.gz"
    exit 1
fi

# Décompression du fichier FASTQ
gunzip -c barcode12_trim_reads.fastq.gz > barcode12_trimmed.fastq

# Exécution du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode12_trimmed.fastq \
    --output output_barcode12 \
    --sample barcode12

echo "📁 Fichiers générés :"
ls -lh output_barcode12

# ✅ Création d’un fichier ZIP avec tous les fichiers de sortie
zip -j fastq_qc_barcode12.zip output_barcode12/*.txt

# Nettoyage temporaire
rm -f barcode12_trimmed.fastq
