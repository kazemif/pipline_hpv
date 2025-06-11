#!/bin/bash -ue
cutadapt -j 10 \
    -a file:HBV_primer.fasta \
    --discard-untrimmed \
    -m 150 \
    -M 1200 \
    -q 10 \
    -o barcode06_trim_reads.fastq.gz \
    barcode06.fastq
