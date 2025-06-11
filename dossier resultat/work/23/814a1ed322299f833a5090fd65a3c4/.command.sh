#!/bin/bash -ue
# Produire SAM
minimap2 -ax map-ont sequence.fasta barcode04_trim_reads.fastq.gz > barcode04.sam

# SAM → BAM trié
samtools view -Sb barcode04.sam | samtools sort -o barcode04.sorted.bam
