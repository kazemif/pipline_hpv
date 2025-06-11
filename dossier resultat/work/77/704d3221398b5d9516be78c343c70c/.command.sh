#!/bin/bash -ue
mkdir -p output/barcode04

# Décompresser le fichier VCF pour qu'il soit lisible
gunzip -c barcode04.sorted.vcf.gz > output/barcode04/barcode04.vcf

# Exécuter le script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode04.sorted.bam \
    -f sequence.fasta \
    -v output/barcode04/barcode04.vcf \
    -ov output/barcode04/barcode04.filtered.vcf \
    -op output/barcode04/barcode04_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
