#!/bin/bash -ue
minimap2 -ax map-ont sequence.fasta barcode09_trim_reads.fastq.gz | \
samtools view -Sb - | \
samtools sort -o barcode09.sorted.bam
