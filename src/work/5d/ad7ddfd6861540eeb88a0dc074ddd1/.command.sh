#!/bin/bash -ue
nb_lines=$(zcat barcode12_trim_reads.fastq.gz | wc -l)
file_size=$(du -h barcode12_trim_reads.fastq.gz | cut -f1)

{
    echo "Sample ID       : barcode12"
    echo "Nombre de lignes: $nb_lines"
    echo "Taille fichier  : $file_size"
} > barcode12_qc.txt
