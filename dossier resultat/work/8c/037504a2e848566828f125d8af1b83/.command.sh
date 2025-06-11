#!/bin/bash -ue
# Mapping avec minimap2 ➜ génère SAM
minimap2 -ax map-ont sequence.fasta barcode12_trim_reads.fastq.gz > barcode12.sam

# Conversion SAM → BAM non trié
samtools view -Sb barcode12.sam > barcode12.bam

# Tri du BAM
samtools sort barcode12.bam -o barcode12.sorted.bam
