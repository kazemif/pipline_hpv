#!/bin/bash -ue
echo "QC report for barcode14" > barcode14_qc.txt
echo "Number of reads: $(zcat barcode14_trim_reads.fastq.gz | wc -l | awk '{print $1/4}')" >> barcode14_qc.txt
echo "Total lines: $(zcat barcode14_trim_reads.fastq.gz | wc -l)" >> barcode14_qc.txt
