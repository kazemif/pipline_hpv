#!/bin/bash -ue
mkdir -p output

gunzip -c barcode10.sorted.vcf.gz > output/barcode10.vcf

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode10.sorted.bam \
    -f sequence.fasta \
    -v output/barcode10.vcf \
    -ov output/barcode10.filtered.vcf \
    -op output/barcode10_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
