#!/bin/bash -ue
set -e
awk '$4 < 20 {print $1, $2, $3}' barcode02.sorted.coverage.bed > barcode02.low_coverage.bed
