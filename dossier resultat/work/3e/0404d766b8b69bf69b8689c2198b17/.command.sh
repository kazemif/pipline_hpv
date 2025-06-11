#!/bin/bash -ue
# Mapping avec minimap2 ➜ génère SAM
minimap2 -ax map-ont sequence.fasta barcode07_trim_reads.fastq.gz > barcode07.sam

# Conversion SAM → BAM non trié
samtools view -Sb barcode07.sam > barcode07.bam

# Tri du BAM
samtools sort barcode07.bam -o barcode07.sorted.bam
