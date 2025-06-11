#!/bin/bash -ue
# 1. Mapping ➜ SAM
minimap2 -ax map-ont sequence.fasta barcode09_trim_reads.fastq.gz > barcode09.sam

# 2. SAM ➜ BAM trié
samtools view -Sb barcode09.sam | samtools sort -o barcode09.sorted.bam
