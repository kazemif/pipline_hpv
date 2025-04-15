#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du fichier VCF
bcftools consensus -f sequence.fasta barcode16.sorted.vcf.gz > barcode16.tmp.fa

# Étape 2 : Masquer les régions de faible couverture avec bedtools
bedtools maskfasta -fi barcode16.tmp.fa -bed barcode16.sorted.coverage.bed -fo barcode16.consensus.fa

# On NE supprime PAS le fichier temporaire ici
