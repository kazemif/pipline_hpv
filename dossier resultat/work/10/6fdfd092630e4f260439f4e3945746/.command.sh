#!/bin/bash -ue
echo "QC report for barcode08" > barcode08_qc.txt
echo "Number of reads: $(zcat barcode08_trim_reads.fastq.gz | wc -l | awk '{print $1/4}')" >> barcode08_qc.txt
echo "Total lines: $(zcat barcode08_trim_reads.fastq.gz | wc -l)" >> barcode08_qc.txt
