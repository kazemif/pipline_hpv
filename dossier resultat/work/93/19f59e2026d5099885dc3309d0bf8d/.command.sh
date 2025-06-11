#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode07"
mkdir -p output_barcode07

# Vérifie que le fichier FASTQ compressé existe
if [ ! -s barcode07_trim_reads.fastq.gz ]; then
    echo "❌ Fichier FASTQ vide ou inexistant : barcode07_trim_reads.fastq.gz"
    exit 1
fi

# Décompression du fichier FASTQ
gunzip -c barcode07_trim_reads.fastq.gz > barcode07_trimmed.fastq

# Exécution du script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode07_trimmed.fastq \
    --output output_barcode07 \
    --sample barcode07

echo "📁 Fichiers générés :"
ls -lh output_barcode07

# Création d’une archive contenant tous les fichiers de sortie
tar -czf fastq_qc_barcode07.tar.gz -C output_barcode07 .

# Nettoyage temporaire
rm -f barcode07_trimmed.fastq
