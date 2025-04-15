#!/bin/bash -ue
nb_lines=$(zcat barcode02_trim_reads.fastq.gz | wc -l)
file_size=$(du -h barcode02_trim_reads.fastq.gz | cut -f1)

{
    echo "Sample ID       : barcode02"
    echo "Nombre de lignes: $nb_lines"
    echo "Taille fichier  : $file_size"
} > barcode02_qc.txt
