#!/bin/bash -ue
bcftools mpileup -d 8000 -f sequence.fasta barcode16.sorted.bam | \
bcftools call -mv | \
bcftools filter -e 'QUAL<20' -Ov -o barcode16.sorted.vcf

bgzip -c barcode16.sorted.vcf > barcode16.sorted.vcf.gz
tabix -p vcf barcode16.sorted.vcf.gz
