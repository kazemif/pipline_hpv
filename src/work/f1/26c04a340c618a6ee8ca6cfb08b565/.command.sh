#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du fichier VCF
bcftools consensus -f sequence.fasta barcode09.sorted.vcf.gz > barcode09.tmp.fa

# Étape 2 : Masquer les régions de faible couverture avec bedtools
bedtools maskfasta -fi barcode09.tmp.fa -bed barcode09.sorted.coverage.bed -fo barcode09.consensus.fa

# On NE supprime PAS le fichier temporaire ici
