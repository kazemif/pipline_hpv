#!/bin/bash -ue
# Décompresser le fichier VCF pour qu'il soit lisible par le script
gunzip -c barcode08.sorted.vcf.gz > barcode08.vcf

# Exécuter le script Python avec le VCF non compressé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode08.sorted.bam \
    -f sequence.fasta \
    -v barcode08.vcf \
    -ov barcode08.filtered.vcf \
    -op barcode08_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
