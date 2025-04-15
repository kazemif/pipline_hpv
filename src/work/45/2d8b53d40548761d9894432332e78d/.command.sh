#!/bin/bash -ue
set -e

# Appel de variants avec filtre qualité, VCF compressé + index
bcftools mpileup -d 8000 -f sequence.fasta barcode13.sorted.bam | \
bcftools call -mv | \
bcftools filter -e 'QUAL<20' -Oz -o barcode13.sorted.vcf.gz

# Indexation du fichier VCF compressé
bcftools index barcode13.sorted.vcf.gz
