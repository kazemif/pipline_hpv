#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du fichier VCF
bcftools consensus -f sequence.fasta barcode14.sorted.vcf.gz > barcode14.tmp.fa

# Étape 2 : Masquer les régions de faible couverture avec bedtools
bedtools maskfasta -fi barcode14.tmp.fa -bed barcode14.sorted.coverage.bed -fo barcode14.consensus.fa

# On NE supprime PAS le fichier temporaire ici
