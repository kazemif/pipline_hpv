#!/bin/bash -ue
set -e

echo "🔹 Mapping de l'échantillon barcode09"

# Exécuter Minimap2 et convertir en BAM trié
minimap2 -t null -a sequence.fasta barcode09_trim_reads.fastq.gz |     samtools view -Sb - |     samtools sort -o barcode09.sorted.bam
