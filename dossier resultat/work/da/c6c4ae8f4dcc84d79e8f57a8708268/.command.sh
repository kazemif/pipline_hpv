#!/bin/bash -ue
minimap2 -ax map-ont sequence.fasta barcode16_trim_reads.fastq.gz | \
samtools view -Sb - | \
samtools sort -o barcode16.sorted.bam
