#!/bin/bash -ue
echo 'Fichier : barcode12_trim_reads.fastq.gz' > barcode12_qc.txt
echo 'Nombre de lignes :' >> barcode12_qc.txt
zcat barcode12_trim_reads.fastq.gz | wc -l >> barcode12_qc.txt
echo 'Taille fichier :' >> barcode12_qc.txt
du -h barcode12_trim_reads.fastq.gz >> barcode12_qc.txt
