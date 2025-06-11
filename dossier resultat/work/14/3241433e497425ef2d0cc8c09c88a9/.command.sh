#!/bin/bash -ue
set -e

# Étape 1 : Générer le consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode02.sorted.vcf.gz > barcode02.tmp.fa

# Étape 2 : Masquer les régions à faible couverture avec bedtools
bedtools maskfasta -fi barcode02.tmp.fa -bed barcode02.sorted.coverage.bed -fo barcode02.consensus.fa

rm barcode02.tmp.fa
