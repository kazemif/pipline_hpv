#!/bin/bash -ue
mkdir -p output/barcode15

# Décompresser le fichier VCF pour qu'il soit lisible
gunzip -c barcode15.sorted.vcf.gz > output/barcode15/barcode15.vcf

# Exécuter le script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode15.sorted.bam \
    -f sequence.fasta \
    -v output/barcode15/barcode15.vcf \
    -ov output/barcode15/barcode15.filtered.vcf \
    -op output/barcode15/barcode15_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
