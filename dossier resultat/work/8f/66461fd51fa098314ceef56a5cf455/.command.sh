#!/bin/bash -ue
mkdir -p output_barcode08

# Appel de ton script Python sans modification
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode08_trim_reads.fastq.gz \
    --output output_barcode08 \
    --sample barcode08

# Renommer proprement le fichier généré
mv output_barcode08/*.csv fastq_qc_barcode08.csv
