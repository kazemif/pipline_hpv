#!/bin/bash -ue
set -e
echo "🔵 Traitement de : barcode03"

mkdir -p output_barcode03

gunzip -c barcode03.sorted.vcf.gz > output_barcode03/barcode03.vcf

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode03.sorted.bam \
    -f sequence.fasta \
    -v output_barcode03/barcode03.vcf \
    -ov output_barcode03/barcode03.filtered.vcf \
    -op output_barcode03/barcode03_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
