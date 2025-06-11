process vcf_indexing {
    input:
        path vcf_gz  // Fichier VCF compressé

    output:
        path "${vcf_gz}.tbi"  // Fichier index du VCF compressé

    script:
        """
        set -e  # Arrêter l'exécution en cas d'erreur

        # Étape 2 : Indexation du fichier VCF compressé
        tabix -p vcf ${vcf_gz}
        """
}
