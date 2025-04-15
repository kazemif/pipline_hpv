#!/bin/bash -ue
set -e

# Étape 1 : Générer le consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode09.sorted.vcf.gz > barcode09.tmp.fa

# Étape 2 : Masquer les régions à faible couverture avec bedtools
bedtools maskfasta -fi barcode09.tmp.fa -bed barcode09.sorted.coverage.bed -fo barcode09.consensus.fa

rm barcode09.tmp.fa
