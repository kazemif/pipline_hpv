#!/bin/bash -ue
bcftools mpileup -d 8000 -f sequence.fasta barcode06.sorted.bam | \
bcftools call -mv | \
bcftools filter -e 'QUAL<20' -Ov -o barcode06.sorted.vcf

bgzip -c barcode06.sorted.vcf > barcode06.sorted.vcf.gz
tabix -p vcf barcode06.sorted.vcf.gz
