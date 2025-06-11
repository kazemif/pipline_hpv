process merge_fastq {
    input:
    tuple val(sample_name), path(in_fastq)

    output:
    path "${sample_name}.fastq.gz"

    script:
    """
    cat ${in_fastq} > ${sample_name}.fastq.gz
    """
}
