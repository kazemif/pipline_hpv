#!/bin/bash -ue
# Étape 1 : Générer un fichier .sam pour parse_read_align
minimap2 -ax map-ont sequence.fasta barcode12_trim_reads.fastq.gz > barcode12.sam

# Étape 2 : Convertir .sam en .bam
samtools view -Sb barcode12.sam > barcode12.bam

# Étape 3 : Trier .bam en .sorted.bam
samtools sort barcode12.bam -o barcode12.sorted.bam

# Remarque : on ne supprime PAS le .sam (il sera utilisé par parse_read_align)
