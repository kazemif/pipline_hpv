#!/bin/bash -ue
echo "🔍 Traitement du fichier BAM pour l'échantillon : barcode04"

# Vérifie si le fichier BAM existe
if [ ! -s barcode04.sorted.bam ]; then
    echo "❌ Fichier BAM vide : barcode04.sorted.bam"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode04.txt
    echo -e "barcode04\tvide\tFichier BAM vide" >> alignment_metrics_barcode04.txt
    exit 0
fi

# Appel du script Python pour analyser le fichier BAM
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input barcode04.sorted.bam \
    --output output_barcode04 \
    --sample barcode04

# Vérifie si le script a bien généré un CSV
CSV_FILE=$(ls output_barcode04/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode04.txt
    echo -e "barcode04\tvide\tPas de métriques disponibles" >> alignment_metrics_barcode04.txt
else
    mv $CSV_FILE alignment_metrics_barcode04.csv
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode04.txt
    echo -e "barcode04\tsuccès\tFichier CSV généré" >> alignment_metrics_barcode04.txt
fi
