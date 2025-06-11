#!/bin/bash -ue
minimap2 -ax map-ont sequence.fasta barcode13_trim_reads.fastq.gz | \
samtools view -Sb - | \
samtools sort -o barcode13.sorted.bam
