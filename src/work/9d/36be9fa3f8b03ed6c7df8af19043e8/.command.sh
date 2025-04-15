#!/bin/bash -ue
bcftools mpileup -d 8000 -f sequence.fasta barcode12.sorted.bam | \
bcftools call -mv | \
bcftools filter -e 'QUAL<20' -Ov -o barcode12.sorted.vcf

bgzip -c barcode12.sorted.vcf > barcode12.sorted.vcf.gz
tabix -p vcf barcode12.sorted.vcf.gz
