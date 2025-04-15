#!/bin/bash -ue
nb_lines=$(zcat barcode10_trim_reads.fastq.gz | wc -l)
file_size=$(du -h barcode10_trim_reads.fastq.gz | cut -f1)

{
    echo "Sample ID       : barcode10"
    echo "Nombre de lignes: $nb_lines"
    echo "Taille fichier  : $file_size"
} > barcode10_qc.txt
