#!/bin/bash -ue
mkdir barcode08_read_align_stats

parse_read_align \
  -i barcode08.sorted.bam \
  -o barcode08_read_align_stats \
  -c 4 \
  -s barcode08
