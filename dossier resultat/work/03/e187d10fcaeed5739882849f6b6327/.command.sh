#!/bin/bash -ue
mkdir -p output

gunzip -c barcode07.sorted.vcf.gz > output/barcode07.vcf

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode07.sorted.bam \
    -f sequence.fasta \
    -v output/barcode07.vcf \
    -ov output/barcode07.filtered.vcf \
    -op output/barcode07_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
