#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode05"
mkdir -p output_barcode05

gunzip -c barcode05.sorted.vcf.gz > output_barcode05/barcode05.vcf

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode05.sorted.bam \
    -f sequence.fasta \
    -v output_barcode05/barcode05.vcf \
    -ov output_barcode05/barcode05.filtered.vcf \
    -op output_barcode05/barcode05_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
