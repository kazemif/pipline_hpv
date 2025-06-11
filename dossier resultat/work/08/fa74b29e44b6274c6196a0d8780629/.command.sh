#!/bin/bash -ue
echo "🔍 Traitement de : barcode14"

if [ ! -s "barcode14.sorted.bam" ]; then
    echo "❌ Fichier vide ou inexistant : barcode14.sorted.bam"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode14.txt
    echo -e "barcode14\tvide\tFichier BAM vide" >> alignment_metrics_barcode14.txt
    exit 0
fi

mkdir -p output_barcode14

# 👉 Copier/renommer le BAM sans .sorted
cp "barcode14.sorted.bam" "barcode14.bam"

# Lancer le script Python sur le fichier renommé
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py \
    --input "barcode14.bam" \
    --output output_barcode14 \
    --sample "barcode14"

# Vérification du CSV
CSV_FILE=$(ls output_barcode14/*.csv 2>/dev/null || true)

if [ -z "$CSV_FILE" ]; then
    echo "⚠️ Aucun fichier CSV généré"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode14.txt
    echo -e "barcode14\tvide\tAucune donnée analysable" >> alignment_metrics_barcode14.txt
else
    mv "$CSV_FILE" "alignment_metrics_barcode14.csv"
    echo -e "sample_id\tstatus\tnote" > alignment_metrics_barcode14.txt
    echo -e "barcode14\tsuccès\tFichier CSV généré" >> alignment_metrics_barcode14.txt
fi
