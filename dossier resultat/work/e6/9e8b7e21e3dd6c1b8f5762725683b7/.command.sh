#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du fichier VCF
bcftools consensus -f sequence.fasta barcode06.sorted.vcf.gz > barcode06.tmp.fa

# Étape 2 : Masquer les régions de faible couverture avec bedtools
bedtools maskfasta -fi barcode06.tmp.fa -bed barcode06.coverage.bed -fo barcode06.consensus.fa

# On NE supprime PAS le fichier temporaire ici
