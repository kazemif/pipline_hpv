#!/bin/bash -ue
set -e

# Étape 1 : Générer le consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode11.sorted.vcf.gz > barcode11.tmp.fa

# Étape 2 : Masquer les régions à faible couverture avec bedtools
bedtools maskfasta -fi barcode11.tmp.fa -bed barcode11.sorted.coverage.bed -fo barcode11.consensus.fa

rm barcode11.tmp.fa
