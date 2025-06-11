#!/bin/bash -ue
echo "🔍 Traitement du fichier BAM pour l'échantillon : barcode08"

# Vérifie si le fichier BAM existe
if [ ! -s barcode08.sorted.bam ]; then
    echo "❌ Fichier BAM vide : barcode08.sorted.bam"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode08.txt
    echo -e "barcode08\tvide\tFichier BAM vide" >> alignment_metrics_barcode08.txt
    exit 0
fi

# Appel du script Python pour analyser le fichier BAM
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input barcode08.sorted.bam \
    --output output_barcode08 \
    --sample barcode08

# Vérifie si le script a bien généré un CSV
CSV_FILE=$(ls output_barcode08/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode08.txt
    echo -e "barcode08\tvide\tPas de métriques disponibles" >> alignment_metrics_barcode08.txt
else
    mv $CSV_FILE alignment_metrics_barcode08.csv
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode08.txt
    echo -e "barcode08\tsuccès\tFichier CSV généré" >> alignment_metrics_barcode08.txt
fi
