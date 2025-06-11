#!/bin/bash -ue
echo 'Fichier : barcode16_trim_reads.fastq.gz' > barcode16_qc.txt
echo 'Nombre de lignes :' >> barcode16_qc.txt
zcat barcode16_trim_reads.fastq.gz | wc -l >> barcode16_qc.txt
echo 'Taille fichier :' >> barcode16_qc.txt
du -h barcode16_trim_reads.fastq.gz >> barcode16_qc.txt
