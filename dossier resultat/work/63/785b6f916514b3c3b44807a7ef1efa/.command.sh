#!/bin/bash -ue
# Produire SAM
minimap2 -ax map-ont sequence.fasta barcode06_trim_reads.fastq.gz > barcode06.sam

# SAM → BAM trié
samtools view -Sb barcode06.sam | samtools sort -o barcode06.sorted.bam
