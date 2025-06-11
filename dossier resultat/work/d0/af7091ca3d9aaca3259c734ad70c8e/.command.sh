#!/bin/bash -ue
set -e
awk '$4 < 20 {print $1, $2, $3}' barcode05.coverage.bed > barcode05.low_coverage.bed
