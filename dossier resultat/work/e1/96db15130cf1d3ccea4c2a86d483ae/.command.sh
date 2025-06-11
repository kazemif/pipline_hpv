#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode08"
mkdir -p output_barcode08

# Vérifie que le fichier FASTQ compressé existe
if [ ! -s barcode08_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode08_trim_reads.fastq.gz"
    exit 1
fi

# Décompression du fichier FASTQ
gunzip -c barcode08_trim_reads.fastq.gz > barcode08_trimmed.fastq

# Exécution du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode08_trimmed.fastq \
    --output output_barcode08 \
    --sample barcode08

echo "📁 Fichiers générés :"
ls -lh output_barcode08

# ✅ Création d’un fichier ZIP avec tous les fichiers de sortie
zip -j fastq_qc_barcode08.zip output_barcode08/*.txt

# Nettoyage temporaire
rm -f barcode08_trimmed.fastq
