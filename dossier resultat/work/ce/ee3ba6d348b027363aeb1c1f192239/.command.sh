#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du fichier VCF
bcftools consensus -f sequence.fasta barcode04.sorted.vcf.gz > barcode04.tmp.fa

# Étape 2 : Masquer les régions de faible couverture avec bedtools
bedtools maskfasta -fi barcode04.tmp.fa -bed barcode04.coverage.bed -fo barcode04.consensus.fa

# On NE supprime PAS le fichier temporaire ici
