#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode08.sorted.vcf.gz > barcode08.tmp.fa

# Étape 2 : Filtrer le fichier BED pour garder uniquement les lignes valides
awk '$2 < $3' barcode08.coverage.bed > barcode08.lowcov.valid.bed

# Étape 3 : Masquer les régions à faible couverture
bedtools maskfasta -fi barcode08.tmp.fa -bed barcode08.lowcov.valid.bed -fo barcode08.consensus.fa
