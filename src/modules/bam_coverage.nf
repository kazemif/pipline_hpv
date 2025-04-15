process bam_coverage {
    input:
        path sorted_bam
        path ref_genome

    output:
        path "${sorted_bam.baseName}.coverage.bed"

    publishDir "${params.result_dir ?: './results'}/${sorted_bam.simpleName}", mode: 'copy'

    script:
    """
    bedtools genomecov -bg -ibam ${sorted_bam} > ${sorted_bam.baseName}.coverage.bed
    """
}



