#!/bin/bash -ue
echo "QC report for barcode15" > barcode15_qc.txt
echo "Number of reads: $(zcat barcode15_trim_reads.fastq.gz | wc -l | awk '{print $1/4}')" >> barcode15_qc.txt
echo "Total lines: $(zcat barcode15_trim_reads.fastq.gz | wc -l)" >> barcode15_qc.txt
