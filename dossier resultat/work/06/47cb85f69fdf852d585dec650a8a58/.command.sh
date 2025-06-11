#!/bin/bash -ue
echo "QC report for barcode02" > barcode02_qc.txt
echo "Number of reads: $(zcat barcode02_trim_reads.fastq.gz | wc -l | awk '{print $1/4}')" >> barcode02_qc.txt
echo "Total lines: $(zcat barcode02_trim_reads.fastq.gz | wc -l)" >> barcode02_qc.txt
