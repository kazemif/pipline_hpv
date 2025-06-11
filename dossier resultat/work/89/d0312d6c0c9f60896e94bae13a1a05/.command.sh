#!/bin/bash -ue
set -e
awk '$4 < 20 {print $1, $2, $3}' barcode07.sorted.coverage.bed > barcode07_low_coverage.bed
