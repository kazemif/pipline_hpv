#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du fichier VCF
bcftools consensus -f sequence.fasta barcode15.sorted.vcf.gz > barcode15.tmp.fa

# Étape 2 : Masquer les régions de faible couverture avec bedtools
bedtools maskfasta -fi barcode15.tmp.fa -bed barcode15.sorted.coverage.bed -fo barcode15.consensus.fa

# On NE supprime PAS le fichier temporaire ici
