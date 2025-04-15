#!/bin/bash -ue
awk '$4 < 20 {print $1, $2, $3}' barcode13.sorted.coverage.bed > barcode13.sorted.coverage_low_coverage.bed
