#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du fichier VCF
bcftools consensus -f sequence.fasta barcode02.sorted.vcf.gz > barcode02.tmp.fa

# Étape 2 : Masquer les régions de faible couverture avec bedtools
bedtools maskfasta -fi barcode02.tmp.fa -bed barcode02.sorted.coverage.bed -fo barcode02.consensus.fa

# On NE supprime PAS le fichier temporaire ici
