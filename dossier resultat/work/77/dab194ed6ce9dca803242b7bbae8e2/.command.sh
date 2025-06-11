#!/bin/bash -ue
mkdir -p output/barcode06

gunzip -c barcode06.sorted.vcf.gz > output/barcode06/barcode06.vcf

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode06.sorted.bam \
    -f sequence.fasta \
    -v output/barcode06/barcode06.vcf \
    -ov output/barcode06/barcode06.filtered.vcf \
    -op output/barcode06/barcode06_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
