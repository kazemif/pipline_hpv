#!/bin/bash -ue
set -e
awk '$4 < 20 {print $1, $2, $3}' barcode12.sorted.coverage.bed > barcode12_low_coverage.bed
