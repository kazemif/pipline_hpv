#!/bin/bash -ue
# Mapping avec minimap2 ➜ génère SAM
minimap2 -ax map-ont sequence.fasta barcode16_trim_reads.fastq.gz > barcode16.sam

# Conversion SAM → BAM non trié
samtools view -Sb barcode16.sam > barcode16.bam

# Tri du BAM
samtools sort barcode16.bam -o barcode16.sorted.bam
