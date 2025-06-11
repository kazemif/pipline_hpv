#!/bin/bash -ue
mkdir -p output/barcode02

# Décompresser le fichier VCF pour qu'il soit lisible
gunzip -c barcode02.sorted.vcf.gz > output/barcode02/barcode02.vcf

# Exécuter le script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode02.sorted.bam \
    -f sequence.fasta \
    -v output/barcode02/barcode02.vcf \
    -ov output/barcode02/barcode02.filtered.vcf \
    -op output/barcode02/barcode02_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
