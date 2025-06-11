#!/bin/bash -ue
set -e
awk '$4 < 20 {print $1, $2, $3}' barcode15.coverage.bed > barcode15.low_coverage.bed
