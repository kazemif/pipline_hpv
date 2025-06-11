#!/bin/bash -ue
echo "🔍 Analyse de barcode10"

mkdir -p output_barcode10

# Lancer le script Python pour générer les .txt
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py         -i "barcode10.sam"         -o output_barcode10         -s "barcode10" || true

# Créer le fichier CSV de statut minimal
CSV_FILE=$(find output_barcode10 -name "*.csv" | head -n 1)
if [ ! -f "$CSV_FILE" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode10.csv
    echo "barcode10;vide;Fichier SAM manquant ou vide" >> alignment_metrics_barcode10.csv
else
    mv "$CSV_FILE" alignment_metrics_barcode10.csv
fi

# Extraire les valeurs et écrire le fichier stat.tsv
READ_COUNT=$(cat output_barcode10/barcode10_read_count.txt 2>/dev/null || echo "NA")
GC_CONTENT=$(cat output_barcode10/barcode10_GC_content.txt 2>/dev/null || echo "NA")
READ_LENGTH=$(cat output_barcode10/barcode10_read_length.txt 2>/dev/null || echo "NA")
MAP_SCORE=$(cat output_barcode10/barcode10_map_score.txt 2>/dev/null || echo "NA")
SEQ_SCORE=$(cat output_barcode10/barcode10_seq_score.txt 2>/dev/null || echo "NA")

echo -e "sample_id	read_count	gc_content	seq_score	read_length	map_score" > stat_barcode10.tsv
echo -e "barcode10	$READ_COUNT	$GC_CONTENT	$SEQ_SCORE	$READ_LENGTH	$MAP_SCORE" >> stat_barcode10.tsv
