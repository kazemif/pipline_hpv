process fastq_qc {
    tag "$sample_name"

    input:
    path fastq_file from fastq_ch
    val sample_name from params.sample_name

    output:
    path "${params.result_dir}/${sample_name}_fastq_qc/"

    script:
    """
    mkdir -p ${params.result_dir}/${sample_name}_fastq_qc
    parse_fastq -i $fastq_file -o ${params.result_dir}/${sample_name}_fastq_qc -c ${params.cpu}

    """
}
