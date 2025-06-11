#!/bin/bash -ue
echo "QC report for barcode04" > barcode04_qc.txt
echo "Number of reads: $(zcat barcode04_trim_reads.fastq.gz | wc -l | awk '{print $1/4}')" >> barcode04_qc.txt
echo "Total lines: $(zcat barcode04_trim_reads.fastq.gz | wc -l)" >> barcode04_qc.txt
