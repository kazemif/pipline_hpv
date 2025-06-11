#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du fichier VCF
bcftools consensus -f sequence.fasta barcode03.sorted.vcf.gz > barcode03.tmp.fa

# Étape 2 : Masquer les régions de faible couverture avec bedtools
bedtools maskfasta -fi barcode03.tmp.fa -bed barcode03.coverage.bed -fo barcode03.consensus.fa

# On NE supprime PAS le fichier temporaire ici
