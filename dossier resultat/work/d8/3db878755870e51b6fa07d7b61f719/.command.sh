#!/bin/bash -ue
# Produire SAM
minimap2 -ax map-ont sequence.fasta barcode08_trim_reads.fastq.gz > barcode08.sam

# SAM → BAM trié
samtools view -Sb barcode08.sam | samtools sort -o barcode08.sorted.bam
