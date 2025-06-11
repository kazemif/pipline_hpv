#!/bin/bash -ue
echo "🔍 Traitement de : barcode16"

if [ ! -s "barcode16.sorted.bam" ]; then
    echo "❌ Fichier vide ou inexistant : barcode16.sorted.bam"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode16.txt
    echo -e "barcode16\tvide\tFichier BAM vide" >> alignment_metrics_barcode16.txt
    exit 0
fi

mkdir -p output_barcode16

# 👉 Copier/renommer le BAM sans .sorted
cp "barcode16.sorted.bam" "barcode16.bam"

# Lancer le script Python sur le fichier renommé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode16.bam" \
    --output output_barcode16 \
    --sample "barcode16"

# Vérification du CSV
CSV_FILE=$(ls output_barcode16/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode16.txt
    echo -e "barcode16\tvide\tAucune donnée analysable" >> alignment_metrics_barcode16.txt
else
    mv "$CSV_FILE" "alignment_metrics_barcode16.csv"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode16.txt
    echo -e "barcode16\tsuccès\tFichier CSV généré" >> alignment_metrics_barcode16.txt
fi
