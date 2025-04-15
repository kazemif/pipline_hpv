#!/bin/bash -ue
nb_lines=$(zcat barcode14_trim_reads.fastq.gz | wc -l)
file_size=$(du -h barcode14_trim_reads.fastq.gz | cut -f1)

{
    echo "Sample ID       : barcode14"
    echo "Nombre de lignes: $nb_lines"
    echo "Taille fichier  : $file_size"
} > barcode14_qc.txt
