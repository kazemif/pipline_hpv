#!/bin/bash -ue
nb_lines=$(zcat barcode06_trim_reads.fastq.gz | wc -l)
file_size=$(du -h barcode06_trim_reads.fastq.gz | cut -f1)

{
    echo "Sample ID       : barcode06"
    echo "Nombre de lignes: $nb_lines"
    echo "Taille fichier  : $file_size"
} > barcode06_qc.txt
