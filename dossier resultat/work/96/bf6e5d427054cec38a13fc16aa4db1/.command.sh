#!/bin/bash -ue
# 1. Mapping ➜ SAM
minimap2 -ax map-ont sequence.fasta barcode08_trim_reads.fastq.gz > barcode08.sam

# 2. SAM ➜ BAM trié
samtools view -Sb barcode08.sam | samtools sort -o barcode08.sorted.bam
