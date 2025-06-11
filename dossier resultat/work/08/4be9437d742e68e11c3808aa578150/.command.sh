#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode11.sorted.vcf.gz > barcode11.tmp.fa

# Étape 2 : Filtrer le fichier BED (important pour éviter les erreurs)
awk '$2 < $3' barcode11.coverage.bed > barcode11.lowcov.valid.bed

# Étape 3 : Masquer les régions à faible couverture
bedtools maskfasta -fi barcode11.tmp.fa -bed barcode11.lowcov.valid.bed -fo barcode11.consensus.fa
