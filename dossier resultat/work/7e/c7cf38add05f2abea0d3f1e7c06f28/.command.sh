#!/bin/bash -ue
# Produire SAM
minimap2 -ax map-ont sequence.fasta barcode01_trim_reads.fastq.gz > barcode01.sam

# SAM → BAM trié
samtools view -Sb barcode01.sam | samtools sort -o barcode01.sorted.bam
