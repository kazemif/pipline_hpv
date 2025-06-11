#!/bin/bash -ue
echo 'Fichier : barcode05_trim_reads.fastq.gz' > barcode05_qc.txt
echo 'Nombre de lignes :' >> barcode05_qc.txt
zcat barcode05_trim_reads.fastq.gz | wc -l >> barcode05_qc.txt
echo 'Taille fichier :' >> barcode05_qc.txt
du -h barcode05_trim_reads.fastq.gz >> barcode05_qc.txt
