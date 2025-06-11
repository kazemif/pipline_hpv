#!/bin/bash -ue
nb_lines=$(zcat barcode01_trim_reads.fastq.gz | wc -l)
file_size=$(du -h barcode01_trim_reads.fastq.gz | cut -f1)

{
    echo "Sample ID       : barcode01"
    echo "Nombre de lignes: $nb_lines"
    echo "Taille fichier  : $file_size"
} > barcode01_qc.txt
