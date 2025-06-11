#!/bin/bash -ue
mkdir -p output/barcode07

# Décompresser le fichier VCF pour qu'il soit lisible
gunzip -c barcode07.sorted.vcf.gz > output/barcode07/barcode07.vcf

# Exécuter le script Python
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode07.sorted.bam \
    -f sequence.fasta \
    -v output/barcode07/barcode07.vcf \
    -ov output/barcode07/barcode07.filtered.vcf \
    -op output/barcode07/barcode07_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50
