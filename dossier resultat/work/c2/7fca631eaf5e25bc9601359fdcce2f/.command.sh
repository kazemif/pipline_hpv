#!/bin/bash -ue
minimap2 -ax map-ont sequence.fasta barcode08_trim_reads.fastq.gz | \
samtools view -Sb - | \
samtools sort -o barcode08.sorted.bam
