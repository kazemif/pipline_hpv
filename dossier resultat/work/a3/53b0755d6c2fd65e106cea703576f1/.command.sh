#!/bin/bash -ue
# Produire SAM
minimap2 -ax map-ont sequence.fasta barcode03_trim_reads.fastq.gz > barcode03.sam

# SAM → BAM trié
samtools view -Sb barcode03.sam | samtools sort -o barcode03.sorted.bam
