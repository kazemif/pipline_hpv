#!/bin/bash -ue
set -e

bcftools query -f '%CHROM\t%POS\t[%DP]\n' barcode09.sorted.vcf.gz | awk '
BEGIN {
    OFS = "\t"
    print "CHROM", "POS", "DP"
}
{
    dp = $3 + 0
    if (dp >= 10)
        print $1, $2, dp
}
' > barcode09_variant_qc.txt
