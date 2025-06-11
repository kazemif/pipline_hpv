#!/bin/bash -ue
set -e

# Étape 1 : Générer le consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode01.sorted.vcf.gz > barcode01.tmp.fa

# Étape 2 : Masquer les régions à faible couverture avec bedtools
bedtools maskfasta -fi barcode01.tmp.fa -bed barcode01.sorted.coverage.bed -fo barcode01.consensus.fa

rm barcode01.tmp.fa
