#!/bin/bash -ue
# Mapping avec minimap2 ➜ génère SAM
minimap2 -ax map-ont sequence.fasta barcode05_trim_reads.fastq.gz > barcode05.sam

# Conversion SAM → BAM non trié
samtools view -Sb barcode05.sam > barcode05.bam

# Tri du BAM
samtools sort barcode05.bam -o barcode05.sorted.bam
