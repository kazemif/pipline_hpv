#!/bin/bash -ue
set -e

# Étape 1 : Générer le consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode13.sorted.vcf.gz > barcode13.tmp.fa

# Étape 2 : Masquer les régions à faible couverture avec bedtools
bedtools maskfasta -fi barcode13.tmp.fa -bed barcode13.sorted.coverage.bed -fo barcode13.consensus.fa

rm barcode13.tmp.fa
