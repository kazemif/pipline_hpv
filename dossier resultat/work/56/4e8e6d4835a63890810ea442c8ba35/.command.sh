#!/bin/bash -ue
mkdir -p output

gunzip -c barcode11.sorted.vcf.gz > output/barcode11.vcf

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode11.sorted.bam \
    -f sequence.fasta \
    -v output/barcode11.vcf \
    -ov output/barcode11.filtered.vcf \
    -op output/barcode11_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
