#!/bin/bash -ue
echo "QC report for barcode01" > barcode01_qc.txt
echo "Number of reads: $(zcat barcode01_trim_reads.fastq.gz | wc -l | awk '{print $1/4}')" >> barcode01_qc.txt
echo "Total lines: $(zcat barcode01_trim_reads.fastq.gz | wc -l)" >> barcode01_qc.txt
