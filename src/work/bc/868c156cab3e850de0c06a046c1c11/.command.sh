#!/bin/bash -ue
set -e

# Étape 1 : Générer le consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode04.sorted.vcf.gz > barcode04.tmp.fa

# Étape 2 : Masquer les régions à faible couverture avec bedtools
bedtools maskfasta -fi barcode04.tmp.fa -bed barcode04.sorted.coverage.bed -fo barcode04.consensus.fa

rm barcode04.tmp.fa
