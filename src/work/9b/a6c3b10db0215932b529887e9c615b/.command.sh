#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du fichier VCF
bcftools consensus -f sequence.fasta barcode12.sorted.vcf.gz > barcode12.tmp.fa

# Étape 2 : Masquer les régions de faible couverture avec bedtools
bedtools maskfasta -fi barcode12.tmp.fa -bed barcode12.sorted.coverage.bed -fo barcode12.consensus.fa

# On NE supprime PAS le fichier temporaire ici
