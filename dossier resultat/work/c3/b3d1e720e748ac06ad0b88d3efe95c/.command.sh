#!/bin/bash -ue
set -e

echo "🔹 Mapping de l'échantillon barcode15"

# Exécuter Minimap2 et convertir en BAM trié
minimap2 -t null -a sequence.fasta barcode15_trim_reads.fastq.gz |     samtools view -Sb - |     samtools sort -o barcode15.sorted.bam
