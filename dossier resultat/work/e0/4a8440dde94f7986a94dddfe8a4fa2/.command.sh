#!/bin/bash -ue
bcftools mpileup -d 8000 -f sequence.fasta barcode03.sorted.bam | \
bcftools call -mv | \
bcftools filter -e 'QUAL<20' -Ov -o barcode03.sorted.vcf

bgzip -c barcode03.sorted.vcf > barcode03.sorted.vcf.gz
tabix -p vcf barcode03.sorted.vcf.gz
