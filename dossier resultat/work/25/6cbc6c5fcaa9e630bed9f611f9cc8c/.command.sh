#!/bin/bash -ue
# Mapping avec minimap2 ➜ génère SAM
minimap2 -ax map-ont sequence.fasta barcode11_trim_reads.fastq.gz > barcode11.sam

# Conversion SAM → BAM non trié
samtools view -Sb barcode11.sam > barcode11.bam

# Tri du BAM
samtools sort barcode11.bam -o barcode11.sorted.bam
