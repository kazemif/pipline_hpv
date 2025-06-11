#!/bin/bash -ue
awk '$4 < 20 {print $1, $2, $3}' barcode03.sorted.coverage.bed > barcode03.sorted.coverage_low_coverage.bed
