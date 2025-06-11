process consensus_generation {
    input:
        path vcf_gz        // Fichier VCF compressé contenant les variants
        path vcf_tbi       // Index du fichier VCF compressé
        path ref_genome    // Génome de référence (FASTA)
        path low_coverage  // Fichier BED des régions à faible couverture

    output:
        path "${vcf_gz.baseName}_consensus.fasta"  // Fichier FASTA final

    script:
        """
        set -e  # Arrêter l'exécution en cas d'erreur

        # Vérification des fichiers
        ls -lh ${vcf_gz} ${vcf_tbi} ${ref_genome} ${low_coverage}

        # Génération du consensus
        bcftools consensus -f ${ref_genome} -m ${low_coverage} ${vcf_gz} > ${vcf_gz.baseName}_consensus.fasta
        """
}

