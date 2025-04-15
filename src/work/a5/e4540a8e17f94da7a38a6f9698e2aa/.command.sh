#!/bin/bash -ue
echo 'Fichier : barcode09_trim_reads.fastq.gz' > barcode09_qc.txt
echo 'Nombre de lignes :' >> barcode09_qc.txt
zcat barcode09_trim_reads.fastq.gz | wc -l >> barcode09_qc.txt
echo 'Taille fichier :' >> barcode09_qc.txt
du -h barcode09_trim_reads.fastq.gz >> barcode09_qc.txt
