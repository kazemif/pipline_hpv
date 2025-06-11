process parse_read_align {
    tag "${sample_id}"

    input:
    tuple val(sample_id), path(sorted_bam), path(sam_file)

    output:
    path "output_${sample_id}/*.txt" // accepte les fichiers .txt générés

    publishDir "${params.result_dir}/${sample_id}/read_alignment_stats", mode: 'copy'

    script:
    """
    echo "🔍 Analyse de ${sample_id}"

    mkdir -p output_${sample_id}

    python3 ${params.bam_qc_script} \\
        -i "${sam_file}" \\
        -o output_${sample_id} \\
        -s "${sample_id}" || true
    """
}





