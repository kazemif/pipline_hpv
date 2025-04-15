#!/bin/bash -ue
echo "QC report for barcode05" > barcode05_qc.txt
echo "Number of reads: $(zcat barcode05_trim_reads.fastq.gz | wc -l | awk '{print $1/4}')" >> barcode05_qc.txt
echo "Total lines: $(zcat barcode05_trim_reads.fastq.gz | wc -l)" >> barcode05_qc.txt
