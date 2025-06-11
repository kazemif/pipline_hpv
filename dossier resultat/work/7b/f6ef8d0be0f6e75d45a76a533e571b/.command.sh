#!/bin/bash -ue
set -e

# Appel de variants avec filtre qualité, VCF compressé
bcftools mpileup -d 8000 -f sequence.fasta barcode01.sorted.bam | \
bcftools call -mv | \
bcftools filter -e 'QUAL<20' -Oz -o barcode01.sorted.vcf.gz

# Indexation avec tabix (format VCF)
tabix -p vcf barcode01.sorted.vcf.gz
