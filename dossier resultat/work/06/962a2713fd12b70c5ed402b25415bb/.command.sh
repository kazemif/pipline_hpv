#!/bin/bash -ue
# Produire SAM
minimap2 -ax map-ont sequence.fasta barcode13_trim_reads.fastq.gz > barcode13.sam

# SAM → BAM trié
samtools view -Sb barcode13.sam | samtools sort -o barcode13.sorted.bam
