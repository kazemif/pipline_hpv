#!/bin/bash -ue
echo "QC report for barcode10" > barcode10_qc.txt
echo "Number of reads: $(zcat barcode10_trim_reads.fastq.gz | wc -l | awk '{print $1/4}')" >> barcode10_qc.txt
echo "Total lines: $(zcat barcode10_trim_reads.fastq.gz | wc -l)" >> barcode10_qc.txt
