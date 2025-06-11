#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode12"
mkdir -p output_barcode12

gunzip -c barcode12.sorted.vcf.gz > output_barcode12/barcode12.vcf

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode12.sorted.bam \
    -f sequence.fasta \
    -v output_barcode12/barcode12.vcf \
    -ov output_barcode12/barcode12.filtered.vcf \
    -op output_barcode12/barcode12_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
