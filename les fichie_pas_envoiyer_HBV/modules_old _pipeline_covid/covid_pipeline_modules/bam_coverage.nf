process bam_coverage {
    input:
        path sorted_bam   // Fichier BAM trié
        path ref_genome   // Fichier de référence du génome

    output:
        path "${sorted_bam.baseName}.coverage.bed"  // Fichier .bed contenant la couverture

    script:
        """
        set -e  # Arrêter l'exécution en cas d'erreur

        # Calcul de la couverture avec bedtools
        bedtools genomecov -bg -ibam ${sorted_bam} > ${sorted_bam.baseName}.coverage.bed
        """
}
