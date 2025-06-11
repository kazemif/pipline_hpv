#!/bin/bash -ue
# Décompresser le fichier VCF pour qu'il soit lisible par le script
gunzip -c barcode09.sorted.vcf.gz > barcode09.vcf

# Exécuter le script Python avec le VCF non compressé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode09.sorted.bam \
    -f sequence.fasta \
    -v barcode09.vcf \
    -ov barcode09.filtered.vcf \
    -op barcode09_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50

# Copier aussi les résultats dans un dossier secondaire
mkdir -p ./results/output/barcode09
cp barcode09.filtered.vcf ./results/output/barcode09/
cp barcode09_pileup.csv ./results/output/barcode09/
