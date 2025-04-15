#!/bin/bash -ue
cutadapt -j 10 \
    -a file:HBV_primer.fasta \
    --discard-untrimmed \
    -m 150 \
    -M 1200 \
    -q 10 \
    -o barcode08_trim_reads.fastq.gz \
    barcode08.fastq
