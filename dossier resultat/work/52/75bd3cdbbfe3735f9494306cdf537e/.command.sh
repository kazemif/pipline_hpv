#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du fichier VCF
bcftools consensus -f sequence.fasta barcode01.sorted.vcf.gz > barcode01.tmp.fa

# Étape 2 : Masquer les régions de faible couverture avec bedtools
bedtools maskfasta -fi barcode01.tmp.fa -bed barcode01.coverage.bed -fo barcode01.consensus.fa

# On NE supprime PAS le fichier temporaire ici
