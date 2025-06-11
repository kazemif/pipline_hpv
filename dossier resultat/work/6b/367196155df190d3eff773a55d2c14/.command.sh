#!/bin/bash -ue
# Décompresser le fichier VCF pour qu'il soit lisible par le script
gunzip -c barcode10.sorted.vcf.gz > barcode10.vcf

# Exécuter le script Python avec le VCF non compressé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode10.sorted.bam \
    -f sequence.fasta \
    -v barcode10.vcf \
    -ov barcode10.filtered.vcf \
    -op barcode10_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
