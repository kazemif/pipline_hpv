#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode10"
mkdir -p 

gunzip -c barcode10.sorted.vcf.gz > output_barcode10/barcode10.vcf

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode10.sorted.bam \
    -f sequence.fasta \
    -v output_barcode10/barcode10.vcf \
    -ov output_barcode10/barcode10.filtered.vcf \
    -op output_barcode10/barcode10_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
