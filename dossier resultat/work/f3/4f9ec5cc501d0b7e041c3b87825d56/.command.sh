#!/bin/bash -ue
# Mapping avec minimap2 ➜ génère SAM
minimap2 -ax map-ont sequence.fasta barcode02_trim_reads.fastq.gz > barcode02.sam

# Conversion SAM → BAM non trié
samtools view -Sb barcode02.sam > barcode02.bam

# Tri du BAM
samtools sort barcode02.bam -o barcode02.sorted.bam
