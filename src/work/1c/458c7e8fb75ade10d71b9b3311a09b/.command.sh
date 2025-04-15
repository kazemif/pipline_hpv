#!/bin/bash -ue
set -e
awk '$4 < 20 {print $1, $2, $3}' barcode09.sorted.coverage.bed > barcode09.low_coverage.bed
