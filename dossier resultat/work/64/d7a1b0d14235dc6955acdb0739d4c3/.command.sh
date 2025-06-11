#!/bin/bash -ue
# Étape 1 : Générer un fichier .sam pour parse_read_align
minimap2 -ax map-ont sequence.fasta barcode10_trim_reads.fastq.gz > barcode10.sam

# Étape 2 : Convertir .sam en .bam
samtools view -Sb barcode10.sam > barcode10.bam

# Étape 3 : Trier .bam en .sorted.bam
samtools sort barcode10.bam -o barcode10.sorted.bam

# Remarque : on ne supprime PAS le .sam (il sera utilisé par parse_read_align)
