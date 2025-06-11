#!/bin/bash -ue
mkdir -p output

gunzip -c barcode01.sorted.vcf.gz > output/barcode01.vcf

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode01.sorted.bam \
    -f sequence.fasta \
    -v output/barcode01.vcf \
    -ov output/barcode01.filtered.vcf \
    -op output/barcode01_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
