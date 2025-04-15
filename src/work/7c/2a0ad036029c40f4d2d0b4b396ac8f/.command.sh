#!/bin/bash -ue
nb_lines=$(zcat barcode04_trim_reads.fastq.gz | wc -l)
file_size=$(du -h barcode04_trim_reads.fastq.gz | cut -f1)

{
    echo "Sample ID       : barcode04"
    echo "Nombre de lignes: $nb_lines"
    echo "Taille fichier  : $file_size"
} > barcode04_qc.txt
