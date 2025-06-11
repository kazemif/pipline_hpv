#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode15.sorted.vcf.gz > barcode15.tmp.fa

# Étape 2 : Filtrer le fichier BED (important pour éviter les erreurs)
awk '$2 < $3' barcode15.coverage.bed > barcode15.lowcov.valid.bed

# Étape 3 : Masquer les régions à faible couverture
bedtools maskfasta -fi barcode15.tmp.fa -bed barcode15.lowcov.valid.bed -fo barcode15.consensus.fa
