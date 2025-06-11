#!/bin/bash -ue
# 1. Mapping ➜ SAM
minimap2 -ax map-ont sequence.fasta barcode15_trim_reads.fastq.gz > barcode15.sam

# 2. SAM ➜ BAM trié
samtools view -Sb barcode15.sam | samtools sort -o barcode15.sorted.bam
