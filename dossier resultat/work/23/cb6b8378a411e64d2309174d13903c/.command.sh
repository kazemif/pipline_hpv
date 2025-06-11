#!/bin/bash -ue
echo "🔍 Traitement du fichier BAM pour l'échantillon : barcode12"

# Vérifie si le fichier BAM existe
if [ ! -s barcode12.sorted.bam ]; then
    echo "❌ Fichier BAM vide : barcode12.sorted.bam"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode12.txt
    echo -e "barcode12\tvide\tFichier BAM vide" >> alignment_metrics_barcode12.txt
    exit 0
fi

# Appel du script Python pour analyser le fichier BAM
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input barcode12.sorted.bam \
    --output output_barcode12 \
    --sample barcode12

# Vérifie si le script a bien généré un CSV
CSV_FILE=$(ls output_barcode12/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode12.txt
    echo -e "barcode12\tvide\tPas de métriques disponibles" >> alignment_metrics_barcode12.txt
else
    mv $CSV_FILE alignment_metrics_barcode12.csv
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode12.txt
    echo -e "barcode12\tsuccès\tFichier CSV généré" >> alignment_metrics_barcode12.txt
fi
