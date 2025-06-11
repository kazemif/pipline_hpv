process parse_variant_qc {
    tag "$sample_id"

    input:
    tuple val(sample_id), path(vcf_file), path(vcf_index), path(bam_file)
    path ref_genome

    output:
    tuple val(sample_id), path("output_${sample_id}/${sample_id}.filtered.vcf"), path("output_${sample_id}/${sample_id}_pileup.csv")

    publishDir "${params.result_dir ?: './results'}/${sample_id}/parse_variant_qc", mode: 'copy'


    script:
    """
    
    set -e
    echo "🔍 Traitement de : ${sample_id}"
    mkdir -p output_${sample_id}

    gunzip -c ${vcf_file} > output_${sample_id}/${sample_id}.vcf

    python3 ${params.variant_qc_script} \\
        -b ${bam_file} \\
        -f ${ref_genome} \\
        -v output_${sample_id}/${sample_id}.vcf \\
        -ov output_${sample_id}/${sample_id}.filtered.vcf \\
        -op output_${sample_id}/${sample_id}_pileup.csv \\
        -c ${params.cpu} \\
        -t 0.2 \\
        -d 50
    """
}

