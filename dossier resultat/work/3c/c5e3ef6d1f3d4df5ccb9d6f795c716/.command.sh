#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du fichier VCF
bcftools consensus -f sequence.fasta barcode11.sorted.vcf.gz > barcode11.tmp.fa

# Étape 2 : Masquer les régions de faible couverture avec bedtools
bedtools maskfasta -fi barcode11.tmp.fa -bed barcode11.coverage.bed -fo barcode11.consensus.fa

# On NE supprime PAS le fichier temporaire ici
