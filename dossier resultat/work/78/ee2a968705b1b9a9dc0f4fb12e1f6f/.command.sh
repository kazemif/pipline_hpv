#!/bin/bash -ue
bcftools mpileup -d 8000 -f sequence.fasta barcode07.sorted.bam | \
bcftools call -mv | \
bcftools filter -e 'QUAL<20' -Ov -o barcode07.sorted.vcf

bgzip -c barcode07.sorted.vcf > barcode07.sorted.vcf.gz
tabix -p vcf barcode07.sorted.vcf.gz
