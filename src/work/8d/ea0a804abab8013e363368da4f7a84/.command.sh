#!/bin/bash -ue
set -e

# Étape 1 : Générer le consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode08.sorted.vcf.gz > barcode08.tmp.fa

# Étape 2 : Masquer les régions à faible couverture avec bedtools
bedtools maskfasta -fi barcode08.tmp.fa -bed barcode08.sorted.coverage.bed -fo barcode08.consensus.fa

rm barcode08.tmp.fa
