#!/bin/bash -ue
set -e
awk '$4 < 20 {print $1, $2, $3}' barcode15.sorted.coverage.bed > barcode15_low_coverage.bed
