#!/bin/bash -ue
echo 'Fichier : barcode06_trim_reads.fastq.gz' > barcode06_qc.txt
echo 'Nombre de lignes :' >> barcode06_qc.txt
zcat barcode06_trim_reads.fastq.gz | wc -l >> barcode06_qc.txt
echo 'Taille fichier :' >> barcode06_qc.txt
du -h barcode06_trim_reads.fastq.gz >> barcode06_qc.txt
