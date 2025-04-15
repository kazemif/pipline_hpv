#!/bin/bash -ue
cutadapt -j 10         -a file:HBV_primer.fasta         --discard-untrimmed         -m 150         -M 1200         -q 10         -o barcode04_trim_reads.fastq.gz         barcode04.fastq
