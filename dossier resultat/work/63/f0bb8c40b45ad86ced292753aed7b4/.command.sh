#!/bin/bash -ue
# Mapping avec minimap2 ➜ génère SAM
minimap2 -ax map-ont sequence.fasta barcode03_trim_reads.fastq.gz > barcode03.sam

# Conversion SAM → BAM non trié
samtools view -Sb barcode03.sam > barcode03.bam

# Tri du BAM
samtools sort barcode03.bam -o barcode03.sorted.bam
