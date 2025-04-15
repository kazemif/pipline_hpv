#!/bin/bash -ue
set -e
awk '$4 < 20 {print $1, $2, $3}' barcode16.sorted.coverage.bed > barcode16_low_coverage.bed
