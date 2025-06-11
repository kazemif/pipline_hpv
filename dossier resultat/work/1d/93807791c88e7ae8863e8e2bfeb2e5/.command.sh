#!/bin/bash -ue
# Mapping avec minimap2 ➜ génère SAM
minimap2 -ax map-ont sequence.fasta barcode15_trim_reads.fastq.gz > barcode15.sam

# Conversion SAM → BAM non trié
samtools view -Sb barcode15.sam > barcode15.bam

# Tri du BAM
samtools sort barcode15.bam -o barcode15.sorted.bam
