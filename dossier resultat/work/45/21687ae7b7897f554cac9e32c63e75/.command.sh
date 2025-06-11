#!/bin/bash -ue
nb_lines=$(zcat barcode03_trim_reads.fastq.gz | wc -l)
file_size=$(du -h barcode03_trim_reads.fastq.gz | cut -f1)

{
    echo "Sample ID       : barcode03"
    echo "Nombre de lignes: $nb_lines"
    echo "Taille fichier  : $file_size"
} > barcode03_qc.txt
