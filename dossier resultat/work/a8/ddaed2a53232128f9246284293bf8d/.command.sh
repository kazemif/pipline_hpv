#!/bin/bash -ue
# Décompresser le fichier VCF pour qu'il soit lisible par le script
gunzip -c barcode15.sorted.vcf.gz > barcode15.vcf

# Exécuter le script Python avec le VCF non compressé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode15.sorted.bam \
    -f sequence.fasta \
    -v barcode15.vcf \
    -ov barcode15.filtered.vcf \
    -op barcode15_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50

# Copier aussi les résultats dans un dossier secondaire
mkdir -p ./results/output/barcode15
cp barcode15.filtered.vcf ./results/output/barcode15/
cp barcode15_pileup.csv ./results/output/barcode15/
