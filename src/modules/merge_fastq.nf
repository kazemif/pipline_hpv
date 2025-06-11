process merge_fastq {
    input:
    tuple val(sample_id), path(fastq_files)

    output:
    tuple val(sample_id), path("${sample_id}.merged.fastq.gz")

    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    cat ${fastq_files.join(' ')} > ${sample_id}.merged.fastq.gz
    """
}



