#!/bin/bash -ue
mkdir -p barcode13_read_alignment_stats
python3 parse_read_align.py \
    --input barcode13.sorted.bam \
    --output barcode13_read_alignment_stats
