#!/bin/bash -ue
# Mapping avec minimap2 ➜ génère SAM
minimap2 -ax map-ont sequence.fasta barcode09_trim_reads.fastq.gz > barcode09.sam

# Conversion SAM → BAM non trié
samtools view -Sb barcode09.sam > barcode09.bam

# Tri du BAM
samtools sort barcode09.bam -o barcode09.sorted.bam
