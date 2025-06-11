#!/bin/bash -ue
echo 'Fichier : barcode03_trim_reads.fastq.gz' > barcode03_qc.txt
echo 'Nombre de lignes :' >> barcode03_qc.txt
zcat barcode03_trim_reads.fastq.gz | wc -l >> barcode03_qc.txt
echo 'Taille fichier :' >> barcode03_qc.txt
du -h barcode03_trim_reads.fastq.gz >> barcode03_qc.txt
