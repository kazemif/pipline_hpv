#!/bin/bash -ue
# Décompresser le fichier VCF pour qu'il soit lisible par le script
gunzip -c barcode13.sorted.vcf.gz > barcode13.vcf

# Exécuter le script Python avec le VCF non compressé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode13.sorted.bam \
    -f sequence.fasta \
    -v barcode13.vcf \
    -ov barcode13.filtered.vcf \
    -op barcode13_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50

# Copier aussi les résultats dans un dossier secondaire
mkdir -p ./results/output/barcode13
cp barcode13.filtered.vcf ./results/output/barcode13/
cp barcode13_pileup.csv ./results/output/barcode13/
