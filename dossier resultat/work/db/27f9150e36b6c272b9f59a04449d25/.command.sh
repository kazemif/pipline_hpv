#!/bin/bash -ue
# 1. Mapping ➜ SAM
minimap2 -ax map-ont sequence.fasta barcode06_trim_reads.fastq.gz > barcode06.sam

# 2. SAM ➜ BAM trié
samtools view -Sb barcode06.sam | samtools sort -o barcode06.sorted.bam
