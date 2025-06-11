#!/bin/bash -ue
set -e
awk '$4 < 20 {print $1, $2, $3}' barcode08.sorted.coverage.bed > barcode08_low_coverage.bed
