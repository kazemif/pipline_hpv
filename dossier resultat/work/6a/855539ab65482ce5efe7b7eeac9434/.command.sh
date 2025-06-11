#!/bin/bash -ue
# Produire SAM
minimap2 -ax map-ont sequence.fasta barcode02_trim_reads.fastq.gz > barcode02.sam

# SAM → BAM trié
samtools view -Sb barcode02.sam | samtools sort -o barcode02.sorted.bam
