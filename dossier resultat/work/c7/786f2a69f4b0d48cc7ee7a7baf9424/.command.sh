#!/bin/bash -ue
set -e

# Étape 1 : Générer le consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode16.sorted.vcf.gz > barcode16.tmp.fa

# Étape 2 : Masquer les régions à faible couverture avec bedtools
bedtools maskfasta -fi barcode16.tmp.fa -bed barcode16.sorted.coverage.bed -fo barcode16.consensus.fa

rm barcode16.tmp.fa
