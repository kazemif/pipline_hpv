process mapping_bam {
    input:
    tuple val(sample_id), path(trimmed_fastq)
    path ref_genome
    val cpu

    output:
    tuple val(sample_id), path("${sample_id}.sorted.bam")

    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    minimap2 -ax map-ont ${ref_genome} ${trimmed_fastq} | \\
    samtools view -Sb - | \\
    samtools sort -o ${sample_id}.sorted.bam
    """
}


