#!/bin/bash -ue
set -e
minimap2 -t 10 -a sequence.fasta barcode01_trim_reads.fastq.gz | \
samtools view -Sb - | \
samtools sort -o barcode01.sorted.bam
