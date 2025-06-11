#!/bin/bash -ue
mkdir -p output

gunzip -c barcode14.sorted.vcf.gz > output/barcode14.vcf

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode14.sorted.bam \
    -f sequence.fasta \
    -v output/barcode14.vcf \
    -ov output/barcode14.filtered.vcf \
    -op output/barcode14_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
