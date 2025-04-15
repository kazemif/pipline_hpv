process trim_reads {
    input:
    tuple val(sample_id), path(fastq_file)
    path adapter_fasta
    val min_len
    val max_len
    val min_qual
    val cpu

    output:
    tuple val(sample_id), path("${sample_id}_trim_reads.fastq.gz")

    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    cutadapt \\
        -a file:${adapter_fasta} \\
        -m ${min_len} -M ${max_len} \\
        -q ${min_qual} \\
        -j ${cpu} \\
        -o ${sample_id}_trim_reads.fastq.gz \\
        ${fastq_file}
    """
}


