#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode02.sorted.vcf.gz > barcode02.tmp.fa

# Étape 2 : Filtrer le fichier BED (important pour éviter les erreurs)
awk '$2 < $3' barcode02.coverage.bed > barcode02.lowcov.valid.bed

# Étape 3 : Masquer les régions à faible couverture
bedtools maskfasta -fi barcode02.tmp.fa -bed barcode02.lowcov.valid.bed -fo barcode02.consensus.fa
