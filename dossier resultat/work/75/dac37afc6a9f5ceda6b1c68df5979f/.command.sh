#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode13.sorted.vcf.gz > barcode13.tmp.fa

# Étape 2 : Filtrer le fichier BED (important pour éviter les erreurs)
awk '$2 < $3' barcode13.coverage.bed > barcode13.lowcov.valid.bed

# Étape 3 : Masquer les régions à faible couverture
bedtools maskfasta -fi barcode13.tmp.fa -bed barcode13.lowcov.valid.bed -fo barcode13.consensus.fa
