#!/bin/bash -ue
nb_lines=$(zcat barcode08_trim_reads.fastq.gz | wc -l)
file_size=$(du -h barcode08_trim_reads.fastq.gz | cut -f1)

{
    echo "Sample ID       : barcode08"
    echo "Nombre de lignes: $nb_lines"
    echo "Taille fichier  : $file_size"
} > barcode08_qc.txt
