#!/bin/bash -ue
mkdir -p output

gunzip -c barcode12.sorted.vcf.gz > output/barcode12.vcf

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode12.sorted.bam \
    -f sequence.fasta \
    -v output/barcode12.vcf \
    -ov output/barcode12.filtered.vcf \
    -op output/barcode12_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
