#!/bin/bash -ue
set -e

echo "🔹 Mapping de l'échantillon barcode16"

# Exécuter Minimap2 et convertir en BAM trié
minimap2 -t null -a sequence.fasta barcode16_trim_reads.fastq.gz |     samtools view -Sb - |     samtools sort -o barcode16.sorted.bam
