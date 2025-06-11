#!/bin/bash -ue
bcftools mpileup -d 8000 -f sequence.fasta barcode13.sorted.bam | \
bcftools call -mv | \
bcftools filter -e 'QUAL<20' -Ov -o barcode13.sorted.vcf

bgzip -c barcode13.sorted.vcf > barcode13.sorted.vcf.gz
tabix -p vcf barcode13.sorted.vcf.gz
