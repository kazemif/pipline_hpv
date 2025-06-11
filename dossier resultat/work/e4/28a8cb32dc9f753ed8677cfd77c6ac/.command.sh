#!/bin/bash -ue
echo "🔍 Analyse de barcode04"

mkdir -p output_barcode04

# Lancer le script Python pour générer les .txt
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_read_align/src/parse_read_align/main.py         -i "barcode04.sam"         -o output_barcode04         -s "barcode04" || true

# Créer le fichier CSV de statut minimal
CSV_FILE=$(find output_barcode04 -name "*.csv" | head -n 1)
if [ ! -f "$CSV_FILE" ]; then
    echo "sample_id;status;note" > alignment_metrics_barcode04.csv
    echo "barcode04;vide;Fichier SAM manquant ou vide" >> alignment_metrics_barcode04.csv
else
    mv "$CSV_FILE" alignment_metrics_barcode04.csv
fi

# Extraire les valeurs et écrire le fichier stat.tsv
READ_COUNT=$(cat output_barcode04/barcode04_read_count.txt 2>/dev/null || echo "NA")
GC_CONTENT=$(cat output_barcode04/barcode04_GC_content.txt 2>/dev/null || echo "NA")
READ_LENGTH=$(cat output_barcode04/barcode04_read_length.txt 2>/dev/null || echo "NA")
MAP_SCORE=$(cat output_barcode04/barcode04_map_score.txt 2>/dev/null || echo "NA")
SEQ_SCORE=$(cat output_barcode04/barcode04_seq_score.txt 2>/dev/null || echo "NA")

echo -e "sample_id	read_count	gc_content	seq_score	read_length	map_score" > stat_barcode04.tsv
echo -e "barcode04	$READ_COUNT	$GC_CONTENT	$SEQ_SCORE	$READ_LENGTH	$MAP_SCORE" >> stat_barcode04.tsv
