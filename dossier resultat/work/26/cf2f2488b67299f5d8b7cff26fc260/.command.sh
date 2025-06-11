#!/bin/bash -ue
cutadapt \
    -a file:HBV_primer.fasta \
    -m 150 -M 1200 \
    -q 10 \
    -j 4 \
    -o barcode13_trim_reads.fastq.gz \
    barcode13.merged.fastq.gz
