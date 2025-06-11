#!/bin/bash -ue
set -e

# Filtrer les régions avec une couverture < 20
awk '$4 < 20 {print $1, $2, $3}' barcode04.sorted.coverage.bed > low_coverage_regions.bed
