#!/bin/bash -ue
# Mapping avec minimap2 ➜ génère SAM
minimap2 -ax map-ont sequence.fasta barcode01_trim_reads.fastq.gz > barcode01.sam

# Conversion SAM → BAM non trié
samtools view -Sb barcode01.sam > barcode01.bam

# Tri du BAM
samtools sort barcode01.bam -o barcode01.sorted.bam
