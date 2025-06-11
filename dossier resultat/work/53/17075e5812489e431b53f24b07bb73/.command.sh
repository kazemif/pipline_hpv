#!/bin/bash -ue
# Produire SAM
minimap2 -ax map-ont sequence.fasta barcode14_trim_reads.fastq.gz > barcode14.sam

# SAM → BAM trié
samtools view -Sb barcode14.sam | samtools sort -o barcode14.sorted.bam
