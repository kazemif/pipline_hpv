#!/bin/bash -ue
echo 'Fichier : barcode07_trim_reads.fastq.gz' > barcode07_qc.txt
echo 'Nombre de lignes :' >> barcode07_qc.txt
zcat barcode07_trim_reads.fastq.gz | wc -l >> barcode07_qc.txt
echo 'Taille fichier :' >> barcode07_qc.txt
du -h barcode07_trim_reads.fastq.gz >> barcode07_qc.txt
