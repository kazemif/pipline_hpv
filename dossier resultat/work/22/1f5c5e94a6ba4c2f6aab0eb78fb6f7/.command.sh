#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode09.sorted.vcf.gz > barcode09.tmp.fa

# Étape 2 : Filtrer le fichier BED (important pour éviter les erreurs)
awk '$2 < $3' barcode09.coverage.bed > barcode09.lowcov.valid.bed

# Étape 3 : Masquer les régions à faible couverture
bedtools maskfasta -fi barcode09.tmp.fa -bed barcode09.lowcov.valid.bed -fo barcode09.consensus.fa
