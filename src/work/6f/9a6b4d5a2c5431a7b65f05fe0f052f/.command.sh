#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du fichier VCF
bcftools consensus -f sequence.fasta barcode13.sorted.vcf.gz > barcode13.tmp.fa

# Étape 2 : Masquer les régions de faible couverture avec bedtools
bedtools maskfasta -fi barcode13.tmp.fa -bed barcode13.sorted.coverage.bed -fo barcode13.consensus.fa

# On NE supprime PAS le fichier temporaire ici
