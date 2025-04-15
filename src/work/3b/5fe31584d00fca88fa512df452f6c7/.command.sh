#!/bin/bash -ue
echo 'Fichier : barcode10_trim_reads.fastq.gz' > barcode10_qc.txt
echo 'Nombre de lignes :' >> barcode10_qc.txt
zcat barcode10_trim_reads.fastq.gz | wc -l >> barcode10_qc.txt
echo 'Taille fichier :' >> barcode10_qc.txt
du -h barcode10_trim_reads.fastq.gz >> barcode10_qc.txt
