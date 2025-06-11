#!/bin/bash -ue
# 1. Mapping ➜ SAM
minimap2 -ax map-ont sequence.fasta barcode07_trim_reads.fastq.gz > barcode07.sam

# 2. SAM ➜ BAM trié
samtools view -Sb barcode07.sam | samtools sort -o barcode07.sorted.bam
