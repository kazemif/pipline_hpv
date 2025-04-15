#!/bin/bash -ue
cutadapt         -a file:HBV_primer.fasta         -m 150 -M 1200 -q 10         -j 4         -o barcode11_trim_reads.fastq.gz         barcode11.merged.fastq.gz
