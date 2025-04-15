#!/bin/bash -ue
minimap2 -ax map-ont sequence.fasta barcode12_trim_reads.fastq.gz | \
samtools view -Sb - | \
samtools sort -o barcode12.sorted.bam
