#!/bin/bash -ue
mkdir -p output/barcode09

# Décompresser le fichier VCF pour qu'il soit lisible
gunzip -c barcode09.sorted.vcf.gz > output/barcode09/barcode09.vcf

# Exécuter le script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode09.sorted.bam \
    -f sequence.fasta \
    -v output/barcode09/barcode09.vcf \
    -ov output/barcode09/barcode09.filtered.vcf \
    -op output/barcode09/barcode09_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
