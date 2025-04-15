#!/bin/bash -ue
echo 'Fichier : barcode08_trim_reads.fastq.gz' > barcode08_qc.txt
echo 'Nombre de lignes :' >> barcode08_qc.txt
zcat barcode08_trim_reads.fastq.gz | wc -l >> barcode08_qc.txt
echo 'Taille fichier :' >> barcode08_qc.txt
du -h barcode08_trim_reads.fastq.gz >> barcode08_qc.txt
