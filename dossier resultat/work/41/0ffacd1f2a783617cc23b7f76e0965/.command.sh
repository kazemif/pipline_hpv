#!/bin/bash -ue
set -e
echo "🔵 Traitement de : barcode14"

mkdir -p output_barcode14

gunzip -c barcode14.sorted.vcf.gz > output_barcode14/barcode14.vcf

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode14.sorted.bam \
    -f sequence.fasta \
    -v output_barcode14/barcode14.vcf \
    -ov output_barcode14/barcode14.filtered.vcf \
    -op output_barcode14/barcode14_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
