#!/bin/bash -ue
cutadapt \
    -a file:HBV_primer.fasta \
    -m 150 -M 1200 \
    -q 10 \
    -j 4 \
    -o barcode09_trim_reads.fastq.gz \
    barcode09.merged.fastq.gz

# Vérifier qu'il y a au moins 1 read (4 lignes = 1 read)
if [ $(zcat barcode09_trim_reads.fastq.gz | wc -l) -lt 4 ]; then
    echo "File too small or invalid: barcode09_trim_reads.fastq.gz"
    exit 1
fi
