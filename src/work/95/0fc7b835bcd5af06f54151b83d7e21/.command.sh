#!/bin/bash -ue
echo "QC report for barcode06" > barcode06_qc.txt
echo "Number of reads: $(zcat barcode06_trim_reads.fastq.gz | wc -l | awk '{print $1/4}')" >> barcode06_qc.txt
echo "Total lines: $(zcat barcode06_trim_reads.fastq.gz | wc -l)" >> barcode06_qc.txt
