#!/bin/bash -ue
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    --input barcode13.sorted.vcf.gz \
    --output barcode13_variant_metrics.csv \
    --sample barcode13
