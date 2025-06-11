#!/bin/bash -ue
echo 'Fichier : barcode11_trim_reads.fastq.gz' > barcode11_qc.txt
echo 'Nombre de lignes :' >> barcode11_qc.txt
zcat barcode11_trim_reads.fastq.gz | wc -l >> barcode11_qc.txt
echo 'Taille fichier :' >> barcode11_qc.txt
du -h barcode11_trim_reads.fastq.gz >> barcode11_qc.txt
