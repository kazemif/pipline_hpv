#!/bin/bash -ue
# 1. Mapping ➜ SAM
minimap2 -ax map-ont sequence.fasta barcode02_trim_reads.fastq.gz > barcode02.sam

# 2. SAM ➜ BAM trié
samtools view -Sb barcode02.sam | samtools sort -o barcode02.sorted.bam
