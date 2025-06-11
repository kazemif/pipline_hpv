#!/bin/bash -ue
bcftools mpileup -d 8000 -f sequence.fasta barcode08.sorted.bam | \
bcftools call -mv | \
bcftools filter -e 'QUAL<20' -Ov -o barcode08.sorted.vcf

bgzip -c barcode08.sorted.vcf > barcode08.sorted.vcf.gz
tabix -p vcf barcode08.sorted.vcf.gz
