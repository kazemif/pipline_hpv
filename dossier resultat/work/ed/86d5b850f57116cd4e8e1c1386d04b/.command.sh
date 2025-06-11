#!/bin/bash -ue
minimap2 -ax map-ont sequence.fasta barcode15_trim_reads.fastq.gz | \
samtools view -Sb - | \
samtools sort -o barcode15.sorted.bam
