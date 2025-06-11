#!/bin/bash -ue
mkdir -p output/barcode05

# Décompresser le fichier VCF pour qu'il soit lisible
gunzip -c barcode05.sorted.vcf.gz > output/barcode05/barcode05.vcf

# Exécuter le script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode05.sorted.bam \
    -f sequence.fasta \
    -v output/barcode05/barcode05.vcf \
    -ov output/barcode05/barcode05.filtered.vcf \
    -op output/barcode05/barcode05_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
