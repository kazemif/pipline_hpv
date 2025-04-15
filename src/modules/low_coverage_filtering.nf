process low_coverage_filtering {

    input:
    tuple val(sample_id), path(coverage_file)

    output:
    path("${sample_id}.low_coverage.bed")

    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    set -e
    awk '\$4 < 20 {print \$1, \$2, \$3}' ${coverage_file} > ${sample_id}.low_coverage.bed
    """
}

