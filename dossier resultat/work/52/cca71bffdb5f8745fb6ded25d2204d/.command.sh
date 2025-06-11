#!/bin/bash -ue
mkdir -p barcode06_read_alignment_stats

# 1. Nombre de reads mappés et unmappés
samtools flagstat barcode06.sorted.bam > barcode06_read_alignment_stats/mapped_unmapped.txt

# 2. Statistiques par read
samtools view barcode06.sorted.bam | awk '
BEGIN {
    OFS="\t"
    print "Read_ID", "Length", "GC_content", "Avg_Quality", "Mapping_Quality"
}
{
    read_id = $1
    seq = $10
    qual = $11
    mapq = $5

    len = length(seq)

    # Calcul GC content
    gc = gsub(/[GCgc]/, "", seq)
    gc_content = len > 0 ? (gc / len) * 100 : 0

    # Calcul average quality
    total_q = 0
    for (i = 1; i <= length(qual); i++) {
        q = substr(qual, i, 1)
        total_q += (ord(q) - 33)
    }
    avg_qual = len > 0 ? total_q / len : 0

    printf "%s\t%d\t%.2f\t%.2f\t%d\n", read_id, len, gc_content, avg_qual, mapq
}

# Fonction ord() en awk pour qualité
function ord(c) {
    return index("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", c) + 32
}

' > barcode06_read_alignment_stats/per_read_stats.tsv
