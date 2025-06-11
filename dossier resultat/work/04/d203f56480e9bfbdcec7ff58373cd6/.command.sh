#!/bin/bash -ue
# 1. Mapping ➜ SAM
minimap2 -ax map-ont sequence.fasta barcode04_trim_reads.fastq.gz > barcode04.sam

# 2. SAM ➜ BAM trié
samtools view -Sb barcode04.sam | samtools sort -o barcode04.sorted.bam
