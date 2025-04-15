#!/bin/bash -ue
set -e

# Appel de variants avec filtre qualité, VCF compressé
bcftools mpileup -d 8000 -f sequence.fasta barcode07.sorted.bam | \
bcftools call -mv | \
bcftools filter -e 'QUAL<20' -Oz -o barcode07.sorted.vcf.gz

# Indexation avec tabix (format VCF)
tabix -p vcf barcode07.sorted.vcf.gz
