#!/bin/bash -ue
set -e

# Étape 1 : Générer le consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode05.sorted.vcf.gz > barcode05.tmp.fa

# Étape 2 : Masquer les régions à faible couverture avec bedtools
bedtools maskfasta -fi barcode05.tmp.fa -bed barcode05.sorted.coverage.bed -fo barcode05.consensus.fa

rm barcode05.tmp.fa
