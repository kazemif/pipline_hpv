#!/bin/bash -ue
nb_lines=$(zcat barcode13_trim_reads.fastq.gz | wc -l)
file_size=$(du -h barcode13_trim_reads.fastq.gz | cut -f1)

{
    echo "Sample ID       : barcode13"
    echo "Nombre de lignes: $nb_lines"
    echo "Taille fichier  : $file_size"
} > barcode13_qc.txt
