#!/bin/bash -ue
minimap2 -ax map-ont sequence.fasta barcode04_trim_reads.fastq.gz | \
samtools view -Sb - | \
samtools sort -o barcode04.sorted.bam
