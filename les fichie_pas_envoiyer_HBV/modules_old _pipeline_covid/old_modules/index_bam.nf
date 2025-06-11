process index_bam {
    input:
    path bam_file // Fichier BAM non indexé

    output:
    path "${bam_file.baseName}.sorted.bam"
    path "${bam_file.baseName}.sorted.bam.bai"

    script:
    """
    samtools sort -o ${bam_file.baseName}.sorted.bam ${bam_file}
    samtools index ${bam_file.baseName}.sorted.bam
    """
}
