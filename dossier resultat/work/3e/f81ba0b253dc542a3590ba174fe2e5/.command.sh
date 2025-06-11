#!/bin/bash -ue
# 1. Mapping ➜ SAM
minimap2 -ax map-ont sequence.fasta barcode11_trim_reads.fastq.gz > barcode11.sam

# 2. SAM ➜ BAM trié
samtools view -Sb barcode11.sam | samtools sort -o barcode11.sorted.bam
