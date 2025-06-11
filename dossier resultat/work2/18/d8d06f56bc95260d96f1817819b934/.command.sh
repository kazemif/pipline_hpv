#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode06.sorted.vcf.gz > barcode06.tmp.fa

# Étape 2 : Filtrer le fichier BED pour garder uniquement les lignes valides
awk '$2 < $3' barcode06.coverage.bed > barcode06.lowcov.valid.bed

# Étape 3 : Masquer les régions à faible couverture
bedtools maskfasta -fi barcode06.tmp.fa -bed barcode06.lowcov.valid.bed -fo barcode06.consensus.fa
