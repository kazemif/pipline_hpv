#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode01.sorted.vcf.gz > barcode01.tmp.fa

# Étape 2 : Filtrer le fichier BED pour garder uniquement les lignes valides
awk '$2 < $3' barcode01.coverage.bed > barcode01.lowcov.valid.bed

# Étape 3 : Masquer les régions à faible couverture
bedtools maskfasta -fi barcode01.tmp.fa -bed barcode01.lowcov.valid.bed -fo barcode01.consensus.fa
