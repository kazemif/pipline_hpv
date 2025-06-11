#!/bin/bash -ue
echo "QC report for barcode03" > barcode03_qc.txt
echo "Number of reads: $(zcat barcode03_trim_reads.fastq.gz | wc -l | awk '{print $1/4}')" >> barcode03_qc.txt
echo "Total lines: $(zcat barcode03_trim_reads.fastq.gz | wc -l)" >> barcode03_qc.txt
