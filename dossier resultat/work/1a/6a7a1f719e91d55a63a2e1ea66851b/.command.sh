#!/bin/bash -ue
echo "QC report for barcode13" > barcode13_qc.txt
echo "Number of reads: $(zcat barcode13_trim_reads.fastq.gz | wc -l | awk '{print $1/4}')" >> barcode13_qc.txt
echo "Total lines: $(zcat barcode13_trim_reads.fastq.gz | wc -l)" >> barcode13_qc.txt
