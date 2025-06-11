#!/bin/bash -ue
# Étape 1 : Générer un fichier .sam pour parse_read_align
minimap2 -ax map-ont sequence.fasta barcode14_trim_reads.fastq.gz > barcode14.sam

# Étape 2 : Convertir .sam en .bam
samtools view -Sb barcode14.sam > barcode14.bam

# Étape 3 : Trier .bam en .sorted.bam
samtools sort barcode14.bam -o barcode14.sorted.bam

# Remarque : on ne supprime PAS le .sam (il sera utilisé par parse_read_align)
