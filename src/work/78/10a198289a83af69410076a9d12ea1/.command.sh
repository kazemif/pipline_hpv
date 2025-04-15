#!/bin/bash -ue
set -e

# Extraction des colonnes CHROM, POS, DP
# et filtrage sur profondeur ≥ 10
bcftools query -f '%CHROM\t%POS\t[%DP]\n' barcode05.sorted.vcf.gz | awk '
BEGIN {
    OFS = ","  # Séparateur CSV
    print "CHROM", "POS", "DP"
}
{
    dp = $3 + 0
    if (dp >= 10)
        print $1, $2, dp
}
' > barcode05_variant_qc.csv
