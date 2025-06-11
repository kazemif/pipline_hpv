#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du fichier VCF
bcftools consensus -f sequence.fasta barcode10.sorted.vcf.gz > barcode10.tmp.fa

# Étape 2 : Masquer les régions de faible couverture avec bedtools
bedtools maskfasta -fi barcode10.tmp.fa -bed barcode10.sorted.coverage.bed -fo barcode10.consensus.fa

# On NE supprime PAS le fichier temporaire ici
