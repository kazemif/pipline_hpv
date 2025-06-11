#!/bin/bash -ue
set -e

# 1) Séquence consensus brute
bcftools consensus -f barcode04.sorted.vcf.gz.tbi barcode04.sorted.vcf.gz > barcode04.tmp.fa

# 2) Masquer les régions low coverage
bedtools maskfasta -fi barcode04.tmp.fa -bed sequence.fasta -fo barcode04.consensus.fa
