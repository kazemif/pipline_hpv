#!/bin/bash -ue
set -e
awk '$4 < 20 {print $1, $2, $3}' barcode03.sorted.coverage.bed > barcode03_low_coverage.bed
