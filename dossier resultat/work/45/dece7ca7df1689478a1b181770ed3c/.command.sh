#!/bin/bash -ue
minimap2 -ax map-ont sequence.fasta barcode03_trim_reads.fastq.gz | \
samtools view -Sb - | \
samtools sort -o barcode03.sorted.bam
