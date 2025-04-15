#!/bin/bash -ue
bcftools mpileup -d 8000 -f sequence.fasta barcode14.sorted.bam | \
bcftools call -mv | \
bcftools filter -e 'QUAL<20' -Ov -o barcode14.sorted.vcf

bgzip -c barcode14.sorted.vcf > barcode14.sorted.vcf.gz
tabix -p vcf barcode14.sorted.vcf.gz
