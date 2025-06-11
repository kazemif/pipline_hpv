#!/bin/bash -ue
# Décompresser le fichier VCF pour qu'il soit lisible par le script
gunzip -c barcode05.sorted.vcf.gz > barcode05.vcf

# Exécuter le script Python avec le VCF non compressé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode05.sorted.bam \
    -f sequence.fasta \
    -v barcode05.vcf \
    -ov barcode05.filtered.vcf \
    -op barcode05_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50

# Copier aussi les résultats dans un dossier secondaire
mkdir -p ./results/output/barcode05
cp barcode05.filtered.vcf ./results/output/barcode05/
cp barcode05_pileup.csv ./results/output/barcode05/
