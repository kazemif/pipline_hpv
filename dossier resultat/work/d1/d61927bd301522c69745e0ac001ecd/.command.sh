#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode03.sorted.vcf.gz > barcode03.tmp.fa

# Étape 2 : Filtrer le fichier BED (important pour éviter les erreurs)
awk '$2 < $3' barcode03.coverage.bed > barcode03.lowcov.valid.bed

# Étape 3 : Masquer les régions à faible couverture
bedtools maskfasta -fi barcode03.tmp.fa -bed barcode03.lowcov.valid.bed -fo barcode03.consensus.fa
