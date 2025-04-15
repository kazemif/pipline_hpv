#!/bin/bash -ue
minimap2 -ax map-ont sequence.fasta barcode02_trim_reads.fastq.gz | \
samtools view -Sb - | \
samtools sort -o barcode02.sorted.bam
