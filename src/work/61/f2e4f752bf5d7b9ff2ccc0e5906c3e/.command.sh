#!/bin/bash -ue
set -e

bcftools query -f '%CHROM\t%POS\t[%DP]\t[%AD]\n' barcode12.sorted.vcf.gz | awk '
BEGIN {
    OFS = "\t"
    print "CHROM", "POS", "DP", "AD", "Relative_AD"
}
{
    chrom = $1
    pos = $2
    dp = $3 + 0
    ad = $4 + 0
    if (dp >= 10 && ad / dp >= 0.25)
        print chrom, pos, dp, ad, ad/dp
}
' > barcode12_variant_qc.txt
