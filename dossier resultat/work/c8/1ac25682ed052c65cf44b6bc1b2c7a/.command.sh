#!/bin/bash -ue
nb_lines=$(zcat barcode11_trim_reads.fastq.gz | wc -l)
file_size=$(du -h barcode11_trim_reads.fastq.gz | cut -f1)

{
    echo "Sample ID       : barcode11"
    echo "Nombre de lignes: $nb_lines"
    echo "Taille fichier  : $file_size"
} > barcode11_qc.txt
