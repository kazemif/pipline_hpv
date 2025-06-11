#!/bin/bash -ue
bcftools mpileup -d 8000 -f sequence.fasta barcode04.sorted.bam | \
bcftools call -mv | \
bcftools filter -e 'QUAL<20' -Ov -o barcode04.sorted.vcf

bgzip -c barcode04.sorted.vcf > barcode04.sorted.vcf.gz
tabix -p vcf barcode04.sorted.vcf.gz
