#!/bin/bash -ue
echo "QC report for barcode12" > barcode12_qc.txt
echo "Number of reads: $(zcat barcode12_trim_reads.fastq.gz | wc -l | awk '{print $1/4}')" >> barcode12_qc.txt
echo "Total lines: $(zcat barcode12_trim_reads.fastq.gz | wc -l)" >> barcode12_qc.txt
