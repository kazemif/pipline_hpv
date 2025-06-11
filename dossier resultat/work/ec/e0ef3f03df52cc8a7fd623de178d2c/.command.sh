#!/bin/bash -ue
# Mapping avec minimap2 ➜ génère SAM
minimap2 -ax map-ont sequence.fasta barcode10_trim_reads.fastq.gz > barcode10.sam

# Conversion SAM → BAM non trié
samtools view -Sb barcode10.sam > barcode10.bam

# Tri du BAM
samtools sort barcode10.bam -o barcode10.sorted.bam
