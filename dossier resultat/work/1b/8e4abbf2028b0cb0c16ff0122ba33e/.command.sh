#!/bin/bash -ue
set -e
echo "🔵 Traitement de : barcode08"

mkdir -p output_barcode08

gunzip -c barcode08.sorted.vcf.gz > output_barcode08/barcode08.vcf

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode08.sorted.bam \
    -f sequence.fasta \
    -v output_barcode08/barcode08.vcf \
    -ov output_barcode08/barcode08.filtered.vcf \
    -op output_barcode08/barcode08_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
