#!/bin/bash -ue
echo "QC report for barcode11" > barcode11_qc.txt
echo "Number of reads: $(zcat barcode11_trim_reads.fastq.gz | wc -l | awk '{print $1/4}')" >> barcode11_qc.txt
echo "Total lines: $(zcat barcode11_trim_reads.fastq.gz | wc -l)" >> barcode11_qc.txt
