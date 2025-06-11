#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du fichier VCF
bcftools consensus -f sequence.fasta barcode05.sorted.vcf.gz > barcode05.tmp.fa

# Étape 2 : Masquer les régions de faible couverture avec bedtools
bedtools maskfasta -fi barcode05.tmp.fa -bed barcode05.sorted.coverage.bed -fo barcode05.consensus.fa

# On NE supprime PAS le fichier temporaire ici
