process merge_fastq {
    input:
        path in_fastq
        val sample_name

    output:
        path "${sample_name}.fastq.gz"

    script:
        """
        cat ${in_fastq} > ${sample_name}.fastq.gz
        """
}

