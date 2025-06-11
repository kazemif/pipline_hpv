process parse_read_align {

    input:
    tuple val(sample_id), path(bam_file)

    output:
    path("${sample_id}_read_alignment_stats/")

    publishDir "${params.result_dir ?: './results'}/${sample_id}/read_alignment_stats", mode: 'copy'

    script:
    """
    mkdir -p ${sample_id}_read_alignment_stats
    python3 parse_read_align.py \\
        --input ${bam_file} \\
        --output ${sample_id}_read_alignment_stats
    """
}


