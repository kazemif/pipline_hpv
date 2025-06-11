#!/bin/bash -ue
mkdir barcode14_read_align_stats

parse_read_align \
  -i barcode14.sorted.bam \
  -o barcode14_read_align_stats \
  -c 4 \
  -s barcode14
