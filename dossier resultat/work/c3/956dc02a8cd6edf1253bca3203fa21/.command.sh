#!/bin/bash -ue
# 1. Mapping ➜ SAM
minimap2 -ax map-ont sequence.fasta barcode10_trim_reads.fastq.gz > barcode10.sam

# 2. SAM ➜ BAM trié
samtools view -Sb barcode10.sam | samtools sort -o barcode10.sorted.bam
