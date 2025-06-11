#!/bin/bash -ue
set -e
awk '$4 < 20 {print $1, $2, $3}' barcode11.sorted.coverage.bed > barcode11_low_coverage.bed
