#!/bin/bash -ue
# Décompresser le fichier VCF pour qu'il soit lisible par le script
gunzip -c barcode12.sorted.vcf.gz > barcode12.vcf

# Exécuter le script Python avec le VCF non compressé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode12.sorted.bam \
    -f sequence.fasta \
    -v barcode12.vcf \
    -ov barcode12.filtered.vcf \
    -op barcode12_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
