#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode10.sorted.vcf.gz > barcode10.tmp.fa

# Étape 2 : Filtrer le fichier BED (important pour éviter les erreurs)
awk '$2 < $3' barcode10.coverage.bed > barcode10.lowcov.valid.bed

# Étape 3 : Masquer les régions à faible couverture
bedtools maskfasta -fi barcode10.tmp.fa -bed barcode10.lowcov.valid.bed -fo barcode10.consensus.fa
