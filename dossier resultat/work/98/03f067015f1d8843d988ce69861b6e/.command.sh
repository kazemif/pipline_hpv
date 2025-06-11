#!/bin/bash -ue
# Décompresser le fichier VCF pour qu'il soit lisible par le script
gunzip -c barcode14.sorted.vcf.gz > barcode14.vcf

# Exécuter le script Python avec le VCF non compressé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode14.sorted.bam \
    -f sequence.fasta \
    -v barcode14.vcf \
    -ov barcode14.filtered.vcf \
    -op barcode14_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50

# Copier aussi les résultats dans un dossier secondaire
mkdir -p ./results/output/barcode14
cp barcode14.filtered.vcf ./results/output/barcode14/
cp barcode14_pileup.csv ./results/output/barcode14/
