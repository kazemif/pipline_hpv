#!/bin/bash -ue
echo "QC report for barcode09" > barcode09_qc.txt
echo "Number of reads: $(zcat barcode09_trim_reads.fastq.gz | wc -l | awk '{print $1/4}')" >> barcode09_qc.txt
echo "Total lines: $(zcat barcode09_trim_reads.fastq.gz | wc -l)" >> barcode09_qc.txt
