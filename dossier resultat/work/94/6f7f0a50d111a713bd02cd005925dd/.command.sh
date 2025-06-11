#!/bin/bash -ue
# Produire SAM
minimap2 -ax map-ont sequence.fasta barcode07_trim_reads.fastq.gz > barcode07.sam

# SAM → BAM trié
samtools view -Sb barcode07.sam | samtools sort -o barcode07.sorted.bam
