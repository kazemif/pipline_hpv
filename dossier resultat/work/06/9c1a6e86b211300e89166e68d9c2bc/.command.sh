#!/bin/bash -ue
mkdir -p output_barcode01

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py     --input barcode01_trim_reads.fastq.gz     --output output_barcode01

# Déplacer le fichier généré dans le bon nom
mv output_barcode01/*.csv fastq_qc_barcode01.csv
