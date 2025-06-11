#!/bin/bash -ue
mkdir -p output_barcode05

# Vérification d'intégrité du FASTQ
gzip -t barcode05_trim_reads.fastq.gz
if [ $? -ne 0 ]; then
    echo "Le fichier FASTQ barcode05_trim_reads.fastq.gz est corrompu ou vide."
    exit 1
fi

# Appel de ton script Python sans modification
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode05_trim_reads.fastq.gz \
    --output output_barcode05 \
    --sample barcode05

# Vérification du fichier généré par Python
if [ ! -f output_barcode05/*.csv ]; then
    echo "Erreur : Le fichier CSV n'a pas été généré."
    exit 1
fi

# Renommer proprement le fichier généré
mv output_barcode05/*.csv fastq_qc_barcode05.csv
