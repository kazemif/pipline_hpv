#!/bin/bash -ue
cutadapt         -a file:HBV_primer.fasta         -m 150 -M 1200 -q 10         -j 4         -o barcode15_trim_reads.fastq.gz         barcode15.merged.fastq.gz
