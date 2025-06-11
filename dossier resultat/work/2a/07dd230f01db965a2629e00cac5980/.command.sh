#!/bin/bash -ue
mkdir -p output_barcode08

# Décompression du fichier .fastq.gz
gunzip -c barcode08_trim_reads.fastq.gz > barcode08_trimmed.fastq

# Appel du script Python avec le fichier FASTQ décompressé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_fastq/src/parse_fastq/main.py \
    --input barcode08_trimmed.fastq \
    --output output_barcode08 \
    --sample barcode08

# Vérification du fichier généré par Python
if [ ! -f output_barcode08/*.csv ]; then
    echo "Erreur : Le fichier CSV n'a pas été généré."
    exit 1
fi

# Renommage propre du fichier de sortie
mv output_barcode08/*.csv fastq_qc_barcode08.csv
