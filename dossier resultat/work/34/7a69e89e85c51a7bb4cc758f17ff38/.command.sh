#!/bin/bash -ue
mkdir -p output_barcode08

# Vérification d'intégrité du FASTQ
gzip -t barcode08_trim_reads.fastq.gz
if [ $? -ne 0 ]; then
    echo "Le fichier FASTQ barcode08_trim_reads.fastq.gz est corrompu ou vide."
    exit 1
fi

# Appel de ton script Python sans modification
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode08_trim_reads.fastq.gz \
    --output output_barcode08 \
    --sample barcode08

# Vérification du fichier généré par Python
if [ ! -f output_barcode08/*.csv ]; then
    echo "Erreur : Le fichier CSV n'a pas été généré."
    exit 1
fi

# Renommer proprement le fichier généré
mv output_barcode08/*.csv fastq_qc_barcode08.csv
