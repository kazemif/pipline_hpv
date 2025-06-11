#!/bin/bash -ue
mkdir -p output_barcode13

# Vérification d'intégrité du FASTQ
gzip -t barcode13_trim_reads.fastq.gz
if [ $? -ne 0 ]; then
    echo "Le fichier FASTQ barcode13_trim_reads.fastq.gz est corrompu ou vide."
    exit 1
fi

# Appel de ton script Python sans modification
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode13_trim_reads.fastq.gz \
    --output output_barcode13 \
    --sample barcode13

# Vérification du fichier généré par Python
if [ ! -f output_barcode13/*.csv ]; then
    echo "Erreur : Le fichier CSV n'a pas été généré."
    exit 1
fi

# Renommer proprement le fichier généré
mv output_barcode13/*.csv fastq_qc_barcode13.csv
