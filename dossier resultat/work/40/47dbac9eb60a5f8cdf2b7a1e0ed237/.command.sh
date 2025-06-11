#!/bin/bash -ue
# Produire SAM
minimap2 -ax map-ont sequence.fasta barcode05_trim_reads.fastq.gz > barcode05.sam

# SAM → BAM trié
samtools view -Sb barcode05.sam | samtools sort -o barcode05.sorted.bam
