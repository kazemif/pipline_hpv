#!/bin/bash -ue
bcftools mpileup -d 8000 -f sequence.fasta barcode10.sorted.bam | \
bcftools call -mv | \
bcftools filter -e 'QUAL<20' -Ov -o barcode10.sorted.vcf

bgzip -c barcode10.sorted.vcf > barcode10.sorted.vcf.gz
tabix -p vcf barcode10.sorted.vcf.gz
