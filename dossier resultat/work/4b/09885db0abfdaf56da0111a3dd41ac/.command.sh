#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode03"
mkdir -p output_barcode03

# Vérifie que le fichier FASTQ compressé existe
if [ ! -s barcode03_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode03_trim_reads.fastq.gz"
    exit 1
fi

# Décompression du fichier FASTQ
gunzip -c barcode03_trim_reads.fastq.gz > barcode03_trimmed.fastq

# Exécution du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode03_trimmed.fastq \
    --output output_barcode03 \
    --sample barcode03

echo "📁 Fichiers générés :"
ls -lh output_barcode03

# Création d’une archive contenant tous les fichiers de sortie
tar -czf fastq_qc_barcode03.tar.gz -C output_barcode03 .

# Nettoyage temporaire
rm -f barcode03_trimmed.fastq
