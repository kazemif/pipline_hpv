#!/bin/bash -ue
echo "QC report for barcode07" > barcode07_qc.txt
echo "Number of reads: $(zcat barcode07_trim_reads.fastq.gz | wc -l | awk '{print $1/4}')" >> barcode07_qc.txt
echo "Total lines: $(zcat barcode07_trim_reads.fastq.gz | wc -l)" >> barcode07_qc.txt
