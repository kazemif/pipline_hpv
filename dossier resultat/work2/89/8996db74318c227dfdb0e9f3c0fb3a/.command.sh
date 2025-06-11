#!/bin/bash -ue
set -e
awk '$4 < 20 {print $1, $2, $3}' barcode13.coverage.bed > barcode13.low_coverage.bed
