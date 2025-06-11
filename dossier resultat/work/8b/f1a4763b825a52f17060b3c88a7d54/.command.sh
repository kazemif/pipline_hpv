#!/bin/bash -ue
echo 'Fichier : barcode14_trim_reads.fastq.gz' > barcode14_qc.txt
echo 'Nombre de lignes :' >> barcode14_qc.txt
zcat barcode14_trim_reads.fastq.gz | wc -l >> barcode14_qc.txt
echo 'Taille fichier :' >> barcode14_qc.txt
du -h barcode14_trim_reads.fastq.gz >> barcode14_qc.txt
