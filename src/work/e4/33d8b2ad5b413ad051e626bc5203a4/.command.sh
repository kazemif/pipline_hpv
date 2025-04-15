#!/bin/bash -ue
echo "QC report for barcode16" > barcode16_qc.txt
echo "Number of reads: $(zcat barcode16_trim_reads.fastq.gz | wc -l | awk '{print $1/4}')" >> barcode16_qc.txt
echo "Total lines: $(zcat barcode16_trim_reads.fastq.gz | wc -l)" >> barcode16_qc.txt
