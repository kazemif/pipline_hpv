process variant_calling {
    tag "$sample_id"

    input:
    tuple val(sample_id), path(bam_file), path(bai_file)
    path ref_genome

    output:
    tuple val(sample_id), path("${sample_id}.sorted.vcf.gz"), path("${sample_id}.sorted.vcf.gz.tbi")

    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    set -e

    # Appel de variants avec filtre qualité, VCF compressé
    bcftools mpileup -d 8000 -f ${ref_genome} ${bam_file} | \\
    bcftools call -mv | \\
    bcftools filter -e 'QUAL<20' -Oz -o ${sample_id}.sorted.vcf.gz

    # Indexation avec tabix (format VCF)
    tabix -p vcf ${sample_id}.sorted.vcf.gz
    """
}

