#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode05.sorted.vcf.gz > barcode05.tmp.fa

# Étape 2 : Filtrer le fichier BED pour garder uniquement les lignes valides
awk '$2 < $3' barcode05.coverage.bed > barcode05.lowcov.valid.bed

# Étape 3 : Masquer les régions à faible couverture
bedtools maskfasta -fi barcode05.tmp.fa -bed barcode05.lowcov.valid.bed -fo barcode05.consensus.fa
