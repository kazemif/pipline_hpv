#!/bin/bash -ue
set -e
awk '$4 < 20 {print $1, $2, $3}' barcode04.coverage.bed > barcode04.low_coverage.bed
