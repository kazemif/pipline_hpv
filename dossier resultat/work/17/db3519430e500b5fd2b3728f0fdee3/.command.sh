#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode11"
mkdir -p output_barcode11

# Vérifie que le fichier FASTQ compressé existe
if [ ! -s barcode11_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode11_trim_reads.fastq.gz"
    exit 1
fi

# Décompression du fichier FASTQ
gunzip -c barcode11_trim_reads.fastq.gz > barcode11_trimmed.fastq

# Exécution du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode11_trimmed.fastq \
    --output output_barcode11 \
    --sample barcode11

echo "📁 Fichiers générés :"
ls -lh output_barcode11

# Création d’une archive contenant tous les fichiers de sortie
tar -czf fastq_qc_barcode11.tar.gz -C output_barcode11 .

# Nettoyage temporaire
rm -f barcode11_trimmed.fastq
