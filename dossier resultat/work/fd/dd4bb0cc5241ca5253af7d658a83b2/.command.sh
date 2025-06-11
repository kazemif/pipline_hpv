#!/bin/bash -ue
# 1. Mapping ➜ SAM
minimap2 -ax map-ont sequence.fasta barcode01_trim_reads.fastq.gz > barcode01.sam

# 2. SAM ➜ BAM trié
samtools view -Sb barcode01.sam | samtools sort -o barcode01.sorted.bam
