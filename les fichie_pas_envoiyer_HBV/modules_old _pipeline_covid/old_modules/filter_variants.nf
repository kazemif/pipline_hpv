process filter_variants {
    input:
    path vcf_file    // Fichier VCF compressé en entrée (.vcf.gz)
    path vcf_index   // Index du fichier VCF (.vcf.gz.csi)
    path ref_genome  // Référence du génome (.fasta)

    output:
    path "${vcf_file.baseName}.filtered.vcf.gz"     // Fichier VCF filtré
    path "${vcf_file.baseName}.filtered.vcf.gz.csi" // Index du fichier filtré

    script:
    def sample_name = vcf_file.baseName

    """
    bcftools filter -e 'QUAL<20 || DP<10' -Oz -o ${sample_name}.filtered.vcf.gz ${vcf_file}
    bcftools index ${sample_name}.filtered.vcf.gz
    """
}

