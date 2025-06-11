#!/bin/bash -ue
# Produire SAM
minimap2 -ax map-ont sequence.fasta barcode15_trim_reads.fastq.gz > barcode15.sam

# SAM → BAM trié
samtools view -Sb barcode15.sam | samtools sort -o barcode15.sorted.bam
