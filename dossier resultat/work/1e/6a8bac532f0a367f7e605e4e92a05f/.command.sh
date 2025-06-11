#!/bin/bash -ue
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode13.sorted.bam \
    -f sequence.fasta \
    -v barcode13.sorted.vcf.gz \
    -ov barcode13.filtered.vcf \
    -op barcode13_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
