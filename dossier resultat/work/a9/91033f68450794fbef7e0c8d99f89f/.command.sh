#!/bin/bash -ue
# Décompresser le fichier VCF pour qu'il soit lisible par le script
gunzip -c barcode04.sorted.vcf.gz > barcode04.vcf

# Exécuter le script Python avec le VCF non compressé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode04.sorted.bam \
    -f sequence.fasta \
    -v barcode04.vcf \
    -ov barcode04.filtered.vcf \
    -op barcode04_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50

# Copier aussi les résultats dans un dossier secondaire
mkdir -p ./results/output/barcode04
cp barcode04.filtered.vcf ./results/output/barcode04/
cp barcode04_pileup.csv ./results/output/barcode04/
