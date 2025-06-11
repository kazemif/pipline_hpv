#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode06"
mkdir -p 

gunzip -c barcode06.sorted.vcf.gz > output_barcode06/barcode06.vcf

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode06.sorted.bam \
    -f sequence.fasta \
    -v output_barcode06/barcode06.vcf \
    -ov output_barcode06/barcode06.filtered.vcf \
    -op output_barcode06/barcode06_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
