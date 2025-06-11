#!/bin/bash -ue
# Produire SAM
minimap2 -ax map-ont sequence.fasta barcode09_trim_reads.fastq.gz > barcode09.sam

# SAM → BAM trié
samtools view -Sb barcode09.sam | samtools sort -o barcode09.sorted.bam
