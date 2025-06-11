#!/bin/bash -ue
# Mapping avec minimap2 ➜ génère SAM
minimap2 -ax map-ont sequence.fasta barcode04_trim_reads.fastq.gz > barcode04.sam

# Conversion SAM → BAM non trié
samtools view -Sb barcode04.sam > barcode04.bam

# Tri du BAM
samtools sort barcode04.bam -o barcode04.sorted.bam
