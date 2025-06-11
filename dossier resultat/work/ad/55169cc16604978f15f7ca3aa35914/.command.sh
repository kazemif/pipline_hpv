#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode09"
mkdir -p output_barcode09

gunzip -c barcode09.sorted.vcf.gz > output_barcode09/barcode09.vcf

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode09.sorted.bam \
    -f sequence.fasta \
    -v output_barcode09/barcode09.vcf \
    -ov output_barcode09/barcode09.filtered.vcf \
    -op output_barcode09/barcode09_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
