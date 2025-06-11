#!/bin/bash -ue
# Décompresser le fichier VCF pour qu'il soit lisible par le script
gunzip -c barcode16.sorted.vcf.gz > barcode16.vcf

# Exécuter le script Python avec le VCF non compressé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode16.sorted.bam \
    -f sequence.fasta \
    -v barcode16.vcf \
    -ov barcode16.filtered.vcf \
    -op barcode16_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50

# Copier aussi les résultats dans un dossier secondaire
mkdir -p ./results/output/barcode16
cp barcode16.filtered.vcf ./results/output/barcode16/
cp barcode16_pileup.csv ./results/output/barcode16/
