#!/bin/bash -ue
bcftools mpileup -d 8000 -f sequence.fasta barcode02.sorted.bam | \
bcftools call -mv | \
bcftools filter -e 'QUAL<20' -Ov -o barcode02.sorted.vcf

bgzip -c barcode02.sorted.vcf > barcode02.sorted.vcf.gz
tabix -p vcf barcode02.sorted.vcf.gz
