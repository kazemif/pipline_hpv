process call_variants {
    input:
    path bam_sorted     // Fichier BAM trié
    path bam_indexed    // Index du fichier BAM (.bai)
    path ref_genome     // Référence du génome (.fasta)

    output:
    path "${bam_sorted.baseName}.vcf.gz"     // Fichier VCF compressé contenant les variants
    path "${bam_sorted.baseName}.vcf.gz.csi" // Index du fichier VCF

    script:
    def sample_name = bam_sorted.baseName

    """
    bcftools mpileup -f ${ref_genome} ${bam_sorted} | \
    bcftools call -mv -Oz -o ${sample_name}.vcf.gz
    bcftools index ${sample_name}.vcf.gz
    """
}


