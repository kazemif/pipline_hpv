#!/bin/bash -ue
echo 'Fichier : barcode13_trim_reads.fastq.gz' > barcode13_qc.txt
echo 'Nombre de lignes :' >> barcode13_qc.txt
zcat barcode13_trim_reads.fastq.gz | wc -l >> barcode13_qc.txt
echo 'Taille fichier :' >> barcode13_qc.txt
du -h barcode13_trim_reads.fastq.gz >> barcode13_qc.txt
