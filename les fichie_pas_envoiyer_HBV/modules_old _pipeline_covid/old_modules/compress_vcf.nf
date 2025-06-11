process compress_vcf {
   
    input:
    path vcf_filtered  // Fichier VCF filtré (.vcf.gz)
    path vcf_filtered_index  // Index du fichier VCF filtré (.vcf.gz.csi)

    output:
    path "${vcf_filtered.baseName}.compressed.vcf.gz"
    path "${vcf_filtered.baseName}.compressed.vcf.gz.csi"

    script:
    """
    # Compression du fichier VCF avec bgzip
    bgzip -c ${vcf_filtered} > ${vcf_filtered.baseName}.compressed.vcf.gz

    # Indexation du fichier VCF compressé avec bcftools
    bcftools index ${vcf_filtered.baseName}.compressed.vcf.gz
    
    """
}



