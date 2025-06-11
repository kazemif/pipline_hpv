#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode13"
mkdir -p output_barcode13

gunzip -c barcode13.sorted.vcf.gz > output_barcode13/barcode13.vcf

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode13.sorted.bam \
    -f sequence.fasta \
    -v output_barcode13/barcode13.vcf \
    -ov output_barcode13/barcode13.filtered.vcf \
    -op output_barcode13/barcode13_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
