


process parse_variant_qc {

    input:
    tuple val(sample_id), path(vcf_file)

    output:
    path("${sample_id}_variant_qc.csv")

    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    set -e

    # Extraction des colonnes CHROM, POS, DP, filtrage sur DP ≥ 10
    # et ajout de la colonne sample_id

    bcftools query -f '%CHROM\\t%POS\\t[%DP]\\n' ${vcf_file} | awk -v sample="${sample_id}" '
    BEGIN {
        OFS = ","  # séparateur CSV
        print "sample_id", "POS", "DP"
    }
    {
        dp = \$3 + 0
        if (dp >= 10)
            print sample, \$2, dp
    }
    ' > ${sample_id}_variant_qc.csv
    """
}



