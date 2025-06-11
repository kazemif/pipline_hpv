#!/bin/bash -ue
nb_lines=$(zcat barcode05_trim_reads.fastq.gz | wc -l)
file_size=$(du -h barcode05_trim_reads.fastq.gz | cut -f1)

{
    echo "Sample ID       : barcode05"
    echo "Nombre de lignes: $nb_lines"
    echo "Taille fichier  : $file_size"
} > barcode05_qc.txt
