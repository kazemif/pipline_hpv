#!/bin/bash -ue
set -e
minimap2 -t 10 -a sequence.fasta barcode16_trim_reads.fastq.gz | \
samtools view -Sb - | \
samtools sort -o barcode16.sorted.bam
