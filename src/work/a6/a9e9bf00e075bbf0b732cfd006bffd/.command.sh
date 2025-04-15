#!/bin/bash -ue
nb_lines=$(zcat barcode07_trim_reads.fastq.gz | wc -l)
file_size=$(du -h barcode07_trim_reads.fastq.gz | cut -f1)

{
    echo "Sample ID       : barcode07"
    echo "Nombre de lignes: $nb_lines"
    echo "Taille fichier  : $file_size"
} > barcode07_qc.txt
