#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du VCF
bcftools consensus -f sequence.fasta barcode04.sorted.vcf.gz > barcode04.tmp.fa

# Étape 2 : Filtrer le fichier BED pour garder uniquement les lignes valides
awk '$2 < $3' barcode04.coverage.bed > barcode04.lowcov.valid.bed

# Étape 3 : Masquer les régions à faible couverture
bedtools maskfasta -fi barcode04.tmp.fa -bed barcode04.lowcov.valid.bed -fo barcode04.consensus.fa
