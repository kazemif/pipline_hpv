#!/bin/bash -ue
set -e
awk '$4 < 20 {print $1, $2, $3}' barcode06.sorted.coverage.bed > barcode06.low_coverage.bed
