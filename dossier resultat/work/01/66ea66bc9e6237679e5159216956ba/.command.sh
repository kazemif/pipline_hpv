#!/bin/bash -ue
bedtools genomecov -bg -ibam barcode02.sorted.bam > barcode02.sorted.coverage.bed
