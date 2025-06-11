#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode02"
mkdir -p 

gunzip -c barcode02.sorted.vcf.gz > output_barcode02/barcode02.vcf

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode02.sorted.bam \
    -f sequence.fasta \
    -v output_barcode02/barcode02.vcf \
    -ov output_barcode02/barcode02.filtered.vcf \
    -op output_barcode02/barcode02_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
