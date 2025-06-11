process bam_coverage {

    tag "${sample_id}"

    input:
    tuple val(sample_id), path(sorted_bam)
    path genome_file

    output:
    tuple val(sample_id), path("${sample_id}.coverage.bed")

    publishDir "${params.result_dir}/${sample_id}/coverage", mode: 'copy'

    script:
    """
    bedtools genomecov -d -ibam ${sorted_bam} > ${sample_id}.coverage.bed
    """
}
