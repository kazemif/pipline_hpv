#!/bin/bash -ue
set -e

# Extraction des colonnes CHROM, POS, DP, filtrage sur DP ≥ 10
# et ajout de la colonne sample_id

bcftools query -f '%CHROM\t%POS\t[%DP]\n' barcode10.sorted.vcf.gz | awk -v sample="barcode10" '
BEGIN {
    OFS = ","  # séparateur CSV
    print "sample_id", "POS", "DP"
}
{
    dp = $3 + 0
    if (dp >= 10)
        print sample, $2, dp
}
' > barcode10_variant_qc.csv
