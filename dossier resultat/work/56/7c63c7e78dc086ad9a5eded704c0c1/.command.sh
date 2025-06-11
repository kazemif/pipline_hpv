#!/bin/bash -ue
mkdir -p output

gunzip -c barcode16.sorted.vcf.gz > output/barcode16.vcf

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode16.sorted.bam \
    -f sequence.fasta \
    -v output/barcode16.vcf \
    -ov output/barcode16.filtered.vcf \
    -op output/barcode16_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
