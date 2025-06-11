#!/bin/bash -ue
bcftools mpileup -d 8000 -f sequence.fasta barcode01.sorted.bam | \
bcftools call -mv | \
bcftools filter -e 'QUAL<20' -Ov -o barcode01.sorted.vcf

bgzip -c barcode01.sorted.vcf > barcode01.sorted.vcf.gz
tabix -p vcf barcode01.sorted.vcf.gz
