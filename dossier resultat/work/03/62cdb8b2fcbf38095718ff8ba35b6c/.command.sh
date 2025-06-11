#!/bin/bash -ue
set -e
echo "🔵 Traitement de : barcode04"

mkdir -p output_barcode04

gunzip -c barcode04.sorted.vcf.gz > output_barcode04/barcode04.vcf

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode04.sorted.bam \
    -f sequence.fasta \
    -v output_barcode04/barcode04.vcf \
    -ov output_barcode04/barcode04.filtered.vcf \
    -op output_barcode04/barcode04_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
