#!/bin/bash -ue
echo "🔍 Analyse de barcode14"

mkdir -p output_barcode14

# Lancer le script Python pour générer les .txt
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py         -i "barcode14.sam"         -o output_barcode14         -s "barcode14" || true

# Créer le fichier CSV de statut minimal
CSV_FILE=$(find output_barcode14 -name "*.csv" | head -n 1)
if [ ! -f "$CSV_FILE" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode14.csv
    echo "barcode14;vide;Fichier SAM manquant ou vide" >> alignment_metrics_barcode14.csv
else
    mv "$CSV_FILE" alignment_metrics_barcode14.csv
fi

# Extraire les valeurs et écrire le fichier stat.tsv
READ_COUNT=$(cat output_barcode14/barcode14_read_count.txt 2>/dev/null || echo "NA")
GC_CONTENT=$(cat output_barcode14/barcode14_GC_content.txt 2>/dev/null || echo "NA")
READ_LENGTH=$(cat output_barcode14/barcode14_read_length.txt 2>/dev/null || echo "NA")
MAP_SCORE=$(cat output_barcode14/barcode14_map_score.txt 2>/dev/null || echo "NA")
SEQ_SCORE=$(cat output_barcode14/barcode14_seq_score.txt 2>/dev/null || echo "NA")

echo -e "sample_id	read_count	gc_content	seq_score	read_length	map_score" > stat_barcode14.tsv
echo -e "barcode14	$READ_COUNT	$GC_CONTENT	$SEQ_SCORE	$READ_LENGTH	$MAP_SCORE" >> stat_barcode14.tsv
