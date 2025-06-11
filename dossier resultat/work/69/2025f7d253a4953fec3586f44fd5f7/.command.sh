#!/bin/bash -ue
# Décompresser le fichier VCF pour qu'il soit lisible par le script
gunzip -c barcode01.sorted.vcf.gz > barcode01.vcf

# Exécuter le script Python avec le VCF non compressé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode01.sorted.bam \
    -f sequence.fasta \
    -v barcode01.vcf \
    -ov barcode01.filtered.vcf \
    -op barcode01_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50

# Copier aussi les résultats dans un dossier secondaire
mkdir -p ./results/output/barcode01
cp barcode01.filtered.vcf ./results/output/barcode01/
cp barcode01_pileup.csv ./results/output/barcode01/
