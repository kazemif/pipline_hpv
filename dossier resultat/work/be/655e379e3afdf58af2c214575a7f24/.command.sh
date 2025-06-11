#!/bin/bash -ue
mkdir barcode05_read_align_stats
parse_read_align \
  -i barcode05.sorted.bam \
  -o barcode05_read_align_stats \
  -c null \
  -s barcode05
