#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode15"
mkdir -p output_barcode15

gunzip -c barcode15.sorted.vcf.gz > output_barcode15/barcode15.vcf

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode15.sorted.bam \
    -f sequence.fasta \
    -v output_barcode15/barcode15.vcf \
    -ov output_barcode15/barcode15.filtered.vcf \
    -op output_barcode15/barcode15_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
