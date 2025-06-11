#!/bin/bash -ue
set -e

# Étape 1 : Générer le consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode14.sorted.vcf.gz > barcode14.tmp.fa

# Étape 2 : Masquer les régions à faible couverture avec bedtools
bedtools maskfasta -fi barcode14.tmp.fa -bed barcode14.sorted.coverage.bed -fo barcode14.consensus.fa

rm barcode14.tmp.fa
