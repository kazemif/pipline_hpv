#!/bin/bash -ue
mkdir barcode13_read_align_stats
parse_read_align \
  -i barcode13.sorted.bam \
  -o barcode13_read_align_stats \
  -c 4 \
  -s barcode13
