#!/bin/bash -ue
minimap2 -ax map-ont sequence.fasta barcode14_trim_reads.fastq.gz | \
samtools view -Sb - | \
samtools sort -o barcode14.sorted.bam
