#!/bin/bash -ue
set -e
awk '$4 < 20 {print $1, $2, $3}' barcode04.sorted.coverage.bed > barcode04_low_coverage.bed
