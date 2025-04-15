#!/bin/bash -ue
set -e
awk '$4 < 20 {print $1, $2, $3}' barcode01.sorted.coverage.bed > barcode01_low_coverage.bed
