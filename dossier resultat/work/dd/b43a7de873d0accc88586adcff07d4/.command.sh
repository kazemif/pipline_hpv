#!/bin/bash -ue
set -e

# Étape 1 : Générer le consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode10.sorted.vcf.gz > barcode10.tmp.fa

# Étape 2 : Masquer les régions à faible couverture avec bedtools
bedtools maskfasta -fi barcode10.tmp.fa -bed barcode10.sorted.coverage.bed -fo barcode10.consensus.fa

rm barcode10.tmp.fa
