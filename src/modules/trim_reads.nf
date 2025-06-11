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

# Vérifier qu'il y a au moins 1 read (4 lignes = 1 read)
if [ \$(zcat ${sample_id}_trim_reads.fastq.gz | wc -l) -lt 4 ]; then
    echo "File too small or invalid: ${sample_id}_trim_reads.fastq.gz"
    exit 1
fi
"""
}





