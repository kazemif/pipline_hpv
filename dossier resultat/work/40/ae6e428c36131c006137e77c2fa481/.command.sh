#!/bin/bash -ue
bedtools genomecov -bg -ibam barcode16.sorted.bam > barcode16.sorted.coverage.bed
