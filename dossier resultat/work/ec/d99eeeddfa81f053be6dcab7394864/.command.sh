#!/bin/bash -ue
set -e

# Étape 1 : Générer le consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode06.sorted.vcf.gz > barcode06.tmp.fa

# Étape 2 : Masquer les régions à faible couverture avec bedtools
bedtools maskfasta -fi barcode06.tmp.fa -bed barcode06.sorted.coverage.bed -fo barcode06.consensus.fa

rm barcode06.tmp.fa
