#!/bin/bash -ue
echo 'Fichier : barcode02_trim_reads.fastq.gz' > barcode02_qc.txt
echo 'Nombre de lignes :' >> barcode02_qc.txt
zcat barcode02_trim_reads.fastq.gz | wc -l >> barcode02_qc.txt
echo 'Taille fichier :' >> barcode02_qc.txt
du -h barcode02_trim_reads.fastq.gz >> barcode02_qc.txt
