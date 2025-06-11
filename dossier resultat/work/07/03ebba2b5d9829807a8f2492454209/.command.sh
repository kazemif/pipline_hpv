#!/bin/bash -ue
set -e

# Étape 1 : Générer le consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode12.sorted.vcf.gz > barcode12.tmp.fa

# Étape 2 : Masquer les régions à faible couverture avec bedtools
bedtools maskfasta -fi barcode12.tmp.fa -bed barcode12.sorted.coverage.bed -fo barcode12.consensus.fa

rm barcode12.tmp.fa
