#!/bin/bash -ue
set -e
minimap2 -t 10 -a sequence.fasta barcode10_trim_reads.fastq.gz | \
samtools view -Sb - | \
samtools sort -o barcode10.sorted.bam
