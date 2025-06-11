#!/bin/bash -ue
set -e
awk '$4 < 20 {print $1, $2, $3}' barcode03.coverage.bed > barcode03.low_coverage.bed
