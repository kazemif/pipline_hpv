#!/bin/bash -ue
# Mapping avec minimap2 ➜ génère SAM
minimap2 -ax map-ont sequence.fasta barcode14_trim_reads.fastq.gz > barcode14.sam

# Conversion SAM → BAM non trié
samtools view -Sb barcode14.sam > barcode14.bam

# Tri du BAM
samtools sort barcode14.bam -o barcode14.sorted.bam
