#!/bin/bash -ue
# 1. Mapping ➜ SAM
minimap2 -ax map-ont sequence.fasta barcode16_trim_reads.fastq.gz > barcode16.sam

# 2. SAM ➜ BAM trié
samtools view -Sb barcode16.sam | samtools sort -o barcode16.sorted.bam
