process mapping_bam {
    input:
    tuple val(sample_id), path(trimmed_fastq)
    path ref_genome
    val cpu

    output:
    tuple val(sample_id), path("${sample_id}.sorted.bam"), path("${sample_id}.sam")

    publishDir "${params.result_dir}/${sample_id}", mode: 'copy'

    script:
    """
    # Produire SAM
    minimap2 -ax map-ont ${ref_genome} ${trimmed_fastq} > ${sample_id}.sam

    # SAM → BAM trié
    samtools view -Sb ${sample_id}.sam | samtools sort -o ${sample_id}.sorted.bam
    """
}






