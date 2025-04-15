#!/bin/bash -ue
nb_lines=$(zcat barcode16_trim_reads.fastq.gz | wc -l)
file_size=$(du -h barcode16_trim_reads.fastq.gz | cut -f1)

{
    echo "Sample ID       : barcode16"
    echo "Nombre de lignes: $nb_lines"
    echo "Taille fichier  : $file_size"
} > barcode16_qc.txt
