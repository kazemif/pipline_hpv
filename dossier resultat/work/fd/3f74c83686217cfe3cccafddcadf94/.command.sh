#!/bin/bash -ue
mkdir barcode02_read_align_stats
parse_read_align \
  -i barcode02.sorted.bam \
  -o barcode02_read_align_stats \
  -c null \
  -s barcode02
