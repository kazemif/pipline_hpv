#!/bin/bash -ue
mkdir -p output/barcode13

# Décompresser le fichier VCF pour qu'il soit lisible
gunzip -c barcode13.sorted.vcf.gz > output/barcode13/barcode13.vcf

# Exécuter le script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode13.sorted.bam \
    -f sequence.fasta \
    -v output/barcode13/barcode13.vcf \
    -ov output/barcode13/barcode13.filtered.vcf \
    -op output/barcode13/barcode13_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
