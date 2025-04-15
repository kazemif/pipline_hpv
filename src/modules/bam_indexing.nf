process bam_indexing {
    input:
    tuple val(sample_id), path(sorted_bam)

    output:
    tuple val(sample_id), path("${sorted_bam}.bai")

    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    samtools index ${sorted_bam}
    """
}
