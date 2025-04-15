#!/bin/bash -ue
echo 'Fichier : barcode01_trim_reads.fastq.gz' > barcode01_qc.txt
echo 'Nombre de lignes :' >> barcode01_qc.txt
zcat barcode01_trim_reads.fastq.gz | wc -l >> barcode01_qc.txt
echo 'Taille fichier :' >> barcode01_qc.txt
du -h barcode01_trim_reads.fastq.gz >> barcode01_qc.txt
