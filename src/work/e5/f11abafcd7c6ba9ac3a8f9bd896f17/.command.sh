#!/bin/bash -ue
echo 'Fichier : barcode04_trim_reads.fastq.gz' > barcode04_qc.txt
echo 'Nombre de lignes :' >> barcode04_qc.txt
zcat barcode04_trim_reads.fastq.gz | wc -l >> barcode04_qc.txt
echo 'Taille fichier :' >> barcode04_qc.txt
du -h barcode04_trim_reads.fastq.gz >> barcode04_qc.txt
