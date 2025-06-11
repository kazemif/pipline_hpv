process bam_indexing {
    tag "${sample_id}"

    input:
    tuple val(sample_id), path(sorted_bam), path(_)  // accepte 3, utilise 2

    output:
    tuple val(sample_id), path("${sorted_bam}.bai")

    publishDir "${params.result_dir}/${sample_id}", mode: 'copy'

    script:
    """
    samtools index ${sorted_bam}
    """
}


