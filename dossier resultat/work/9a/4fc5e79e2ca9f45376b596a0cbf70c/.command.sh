#!/bin/bash -ue
# Mapping avec minimap2 ➜ génère SAM
minimap2 -ax map-ont sequence.fasta barcode08_trim_reads.fastq.gz > barcode08.sam

# Conversion SAM → BAM non trié
samtools view -Sb barcode08.sam > barcode08.bam

# Tri du BAM
samtools sort barcode08.bam -o barcode08.sorted.bam
