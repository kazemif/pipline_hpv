#!/bin/bash -ue
bcftools mpileup -d 8000 -f sequence.fasta barcode15.sorted.bam | \
bcftools call -mv | \
bcftools filter -e 'QUAL<20' -Ov -o barcode15.sorted.vcf

bgzip -c barcode15.sorted.vcf > barcode15.sorted.vcf.gz
tabix -p vcf barcode15.sorted.vcf.gz
