#!/bin/bash -ue
set -e

# Étape 1 : Générer la séquence consensus à partir du fichier VCF
bcftools consensus -f sequence.fasta barcode07.sorted.vcf.gz > barcode07.tmp.fa

# Étape 2 : Masquer les régions de faible couverture avec bedtools
bedtools maskfasta -fi barcode07.tmp.fa -bed barcode07.coverage.bed -fo barcode07.consensus.fa

# On NE supprime PAS le fichier temporaire ici
