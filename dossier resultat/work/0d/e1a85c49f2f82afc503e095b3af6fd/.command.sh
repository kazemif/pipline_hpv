#!/bin/bash -ue
set -e

# Appel de variants avec filtre qualité, VCF compressé
bcftools mpileup -d 8000 -f sequence.fasta barcode02.sorted.bam | \
bcftools call -mv | \
bcftools filter -e 'QUAL<20' -Oz -o barcode02.sorted.vcf.gz

# Indexation avec tabix (format VCF)
tabix -p vcf barcode02.sorted.vcf.gz
