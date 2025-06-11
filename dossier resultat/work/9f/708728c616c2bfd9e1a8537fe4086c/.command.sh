#!/bin/bash -ue
# Mapping avec minimap2 ➜ génère SAM
minimap2 -ax map-ont sequence.fasta barcode13_trim_reads.fastq.gz > barcode13.sam

# Conversion SAM → BAM non trié
samtools view -Sb barcode13.sam > barcode13.bam

# Tri du BAM
samtools sort barcode13.bam -o barcode13.sorted.bam
