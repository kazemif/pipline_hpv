#!/bin/bash -ue
set -e
awk '$4 < 20 {print $1, $2, $3}' barcode11.coverage.bed > barcode11.low_coverage.bed
