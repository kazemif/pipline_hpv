#!/bin/bash -ue
# Décompresser le fichier VCF pour qu'il soit lisible par le script
gunzip -c barcode07.sorted.vcf.gz > barcode07.vcf

# Exécuter le script Python avec le VCF non compressé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    -b barcode07.sorted.bam \
    -f sequence.fasta \
    -v barcode07.vcf \
    -ov barcode07.filtered.vcf \
    -op barcode07_pileup.csv \
    -c 4 \
    -t 0.2 \
    -d 50

# Copier aussi les résultats dans un dossier secondaire
mkdir -p ./results/output/barcode07
cp barcode07.filtered.vcf ./results/output/barcode07/
cp barcode07_pileup.csv ./results/output/barcode07/
