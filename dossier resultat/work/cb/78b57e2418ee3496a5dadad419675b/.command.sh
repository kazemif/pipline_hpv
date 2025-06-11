#!/bin/bash -ue
# Produire SAM
minimap2 -ax map-ont sequence.fasta barcode10_trim_reads.fastq.gz > barcode10.sam

# SAM → BAM trié
samtools view -Sb barcode10.sam | samtools sort -o barcode10.sorted.bam
