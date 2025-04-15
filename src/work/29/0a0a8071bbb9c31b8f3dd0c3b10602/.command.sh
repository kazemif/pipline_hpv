#!/bin/bash -ue
echo 'Fichier : barcode15_trim_reads.fastq.gz' > barcode15_qc.txt
echo 'Nombre de lignes :' >> barcode15_qc.txt
zcat barcode15_trim_reads.fastq.gz | wc -l >> barcode15_qc.txt
echo 'Taille fichier :' >> barcode15_qc.txt
du -h barcode15_trim_reads.fastq.gz >> barcode15_qc.txt
