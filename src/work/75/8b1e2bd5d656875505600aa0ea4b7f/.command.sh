#!/bin/bash -ue
minimap2 -ax map-ont sequence.fasta barcode10_trim_reads.fastq.gz | \
samtools view -Sb - | \
samtools sort -o barcode10.sorted.bam
