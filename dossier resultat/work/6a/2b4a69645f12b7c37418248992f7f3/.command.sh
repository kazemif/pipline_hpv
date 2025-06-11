#!/bin/bash -ue
set -e

# Appel de variants avec filtre qualité, VCF compressé
bcftools mpileup -d 8000 -f sequence.fasta barcode11.sorted.bam | \
bcftools call -mv | \
bcftools filter -e 'QUAL<20' -Oz -o barcode11.sorted.vcf.gz

# Indexation avec tabix (format VCF)
tabix -p vcf barcode11.sorted.vcf.gz
