#!/bin/bash -ue
bcftools mpileup -d 8000 -f sequence.fasta barcode05.sorted.bam | \
bcftools call -mv | \
bcftools filter -e 'QUAL<20' -Ov -o barcode05.sorted.vcf

bgzip -c barcode05.sorted.vcf > barcode05.sorted.vcf.gz
tabix -p vcf barcode05.sorted.vcf.gz
