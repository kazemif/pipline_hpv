#!/bin/bash -ue
mkdir -p output_barcode14

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py     --input barcode14_trim_reads.fastq.gz     --output output_barcode14

# Déplacer le fichier généré dans le bon nom
mv output_barcode14/*.csv fastq_qc_barcode14.csv
