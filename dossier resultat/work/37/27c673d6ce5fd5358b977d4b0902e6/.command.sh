#!/bin/bash -ue
# Décompresser le fichier VCF pour qu'il soit lisible par le script
gunzip -c barcode02.sorted.vcf.gz > barcode02.vcf

# Exécuter le script Python avec le VCF non compressé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode02.sorted.bam \
    -f sequence.fasta \
    -v barcode02.vcf \
    -ov barcode02.filtered.vcf \
    -op barcode02_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50

# Copier aussi les résultats dans un dossier secondaire
mkdir -p ./results/output/barcode02
cp barcode02.filtered.vcf ./results/output/barcode02/
cp barcode02_pileup.csv ./results/output/barcode02/
