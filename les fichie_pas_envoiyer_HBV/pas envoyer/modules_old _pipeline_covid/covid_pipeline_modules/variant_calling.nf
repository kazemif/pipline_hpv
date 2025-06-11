process variant_calling {
    input:
        path sorted_bam   // Fichier BAM trié
        path sorted_bai   // Fichier index BAM
        path ref_genome   // Génome de référence

    output:
        path "${sorted_bam.baseName}.vcf.gz"      // Fichier VCF compressé
        path "${sorted_bam.baseName}.vcf.gz.tbi"  // Index du fichier VCF compressé

    script:
        """
        set -e  # Arrêter l'exécution en cas d'erreur

        # Génération du fichier VCF brut
        bcftools mpileup -d 8000 -f ${ref_genome} ${sorted_bam} | \\
        bcftools call -mv | \\
        bcftools filter -e 'QUAL<20' -Ov -o ${sorted_bam.baseName}.vcf

        # Compression et indexation
        bgzip -c ${sorted_bam.baseName}.vcf > ${sorted_bam.baseName}.vcf.gz
        tabix -p vcf ${sorted_bam.baseName}.vcf.gz
        """
}

