#!/bin/bash -ue
# Étape 1 : Générer un fichier .sam pour parse_read_align
minimap2 -ax map-ont sequence.fasta barcode16_trim_reads.fastq.gz > barcode16.sam

# Étape 2 : Convertir .sam en .bam
samtools view -Sb barcode16.sam > barcode16.bam

# Étape 3 : Trier .bam en .sorted.bam
samtools sort barcode16.bam -o barcode16.sorted.bam

# Remarque : on ne supprime PAS le .sam (il sera utilisé par parse_read_align)
