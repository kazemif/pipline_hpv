#!/bin/bash -ue
minimap2 -ax map-ont sequence.fasta barcode01_trim_reads.fastq.gz | \
samtools view -Sb - | \
samtools sort -o barcode01.sorted.bam
