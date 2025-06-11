#!/bin/bash -ue
bcftools mpileup -d 8000 -f sequence.fasta barcode11.sorted.bam | \
bcftools call -mv | \
bcftools filter -e 'QUAL<20' -Ov -o barcode11.sorted.vcf

bgzip -c barcode11.sorted.vcf > barcode11.sorted.vcf.gz
tabix -p vcf barcode11.sorted.vcf.gz
