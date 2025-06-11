pprocess annotate_variants {
    input:
        path vcf_gz        // Fichier VCF compressé (.vcf.gz)
        path annotation_db // Répertoire contenant les bases de données pour l’annotation?

    output:
        path "${vcf_gz.baseName}_annotated.vcf.gz"  // Fichier VCF annoté compressé
        path "${vcf_gz.baseName}_annotated.vcf.gz.tbi"  // Index de l'annotation

    script:
        """
        set -e  # Arrêter en cas d'erreur

        # Annotation des variants avec VEP
        vep --input_file ${vcf_gz} \\
            --output_file ${vcf_gz.baseName}_annotated.vcf.gz \\
            --format vcf --vcf \\
            --cache --dir_cache ${annotation_db} \\
            --everything

        # Indexation du fichier annoté
        tabix -p vcf ${vcf_gz.baseName}_annotated.vcf.gz
        """
}
