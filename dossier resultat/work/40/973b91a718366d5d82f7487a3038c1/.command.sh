#!/bin/bash -ue
set -e
echo "🔵 Traitement de : barcode11"

mkdir -p output_barcode11

gunzip -c barcode11.sorted.vcf.gz > output_barcode11/barcode11.vcf

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode11.sorted.bam \
    -f sequence.fasta \
    -v output_barcode11/barcode11.vcf \
    -ov output_barcode11/barcode11.filtered.vcf \
    -op output_barcode11/barcode11_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
