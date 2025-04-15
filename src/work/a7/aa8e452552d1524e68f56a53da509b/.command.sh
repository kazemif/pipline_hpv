#!/bin/bash -ue
bcftools mpileup -d 8000 -f sequence.fasta barcode09.sorted.bam | \
bcftools call -mv | \
bcftools filter -e 'QUAL<20' -Ov -o barcode09.sorted.vcf

bgzip -c barcode09.sorted.vcf > barcode09.sorted.vcf.gz
tabix -p vcf barcode09.sorted.vcf.gz
