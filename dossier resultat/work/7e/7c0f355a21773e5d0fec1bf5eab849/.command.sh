#!/bin/bash -ue
set -e

# Étape 1 : Générer le consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode15.sorted.vcf.gz > barcode15.tmp.fa

# Étape 2 : Masquer les régions à faible couverture avec bedtools
bedtools maskfasta -fi barcode15.tmp.fa -bed barcode15.sorted.coverage.bed -fo barcode15.consensus.fa

rm barcode15.tmp.fa
