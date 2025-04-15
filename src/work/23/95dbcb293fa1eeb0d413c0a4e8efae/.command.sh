#!/bin/bash -ue
set -e

# Étape 1 : Générer le consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode07.sorted.vcf.gz > barcode07.tmp.fa

# Étape 2 : Masquer les régions à faible couverture avec bedtools
bedtools maskfasta -fi barcode07.tmp.fa -bed barcode07.sorted.coverage.bed -fo barcode07.consensus.fa

rm barcode07.tmp.fa
