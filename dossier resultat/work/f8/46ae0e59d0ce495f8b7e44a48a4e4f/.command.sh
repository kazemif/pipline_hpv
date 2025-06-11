#!/bin/bash -ue
mkdir -p output/barcode03

# Décompresser le fichier VCF pour qu'il soit lisible
gunzip -c barcode03.sorted.vcf.gz > output/barcode03/barcode03.vcf

# Exécuter le script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode03.sorted.bam \
    -f sequence.fasta \
    -v output/barcode03/barcode03.vcf \
    -ov output/barcode03/barcode03.filtered.vcf \
    -op output/barcode03/barcode03_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
