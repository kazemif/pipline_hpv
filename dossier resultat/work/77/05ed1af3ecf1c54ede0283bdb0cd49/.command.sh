#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode12.sorted.vcf.gz > barcode12.tmp.fa

# Étape 2 : Filtrer le fichier BED (important pour éviter les erreurs)
awk '$2 < $3' barcode12.coverage.bed > barcode12.lowcov.valid.bed

# Étape 3 : Masquer les régions à faible couverture
bedtools maskfasta -fi barcode12.tmp.fa -bed barcode12.lowcov.valid.bed -fo barcode12.consensus.fa
