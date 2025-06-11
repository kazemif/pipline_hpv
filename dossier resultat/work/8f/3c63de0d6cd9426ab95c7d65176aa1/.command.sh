#!/bin/bash -ue
set -e
echo "🔍 Traitement de : barcode07"
mkdir -p 

gunzip -c barcode07.sorted.vcf.gz > output_barcode07/barcode07.vcf

python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode07.sorted.bam \
    -f sequence.fasta \
    -v output_barcode07/barcode07.vcf \
    -ov output_barcode07/barcode07.filtered.vcf \
    -op output_barcode07/barcode07_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
