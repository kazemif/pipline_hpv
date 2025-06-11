#!/bin/bash -ue
# Mapping avec minimap2 ➜ génère SAM
minimap2 -ax map-ont sequence.fasta barcode06_trim_reads.fastq.gz > barcode06.sam

# Conversion SAM → BAM non trié
samtools view -Sb barcode06.sam > barcode06.bam

# Tri du BAM
samtools sort barcode06.bam -o barcode06.sorted.bam
