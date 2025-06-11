#!/bin/bash -ue
# Produire SAM
minimap2 -ax map-ont sequence.fasta barcode12_trim_reads.fastq.gz > barcode12.sam

# SAM → BAM trié
samtools view -Sb barcode12.sam | samtools sort -o barcode12.sorted.bam
