process low_coverage_filtering {
    input:
        path coverage_bed  // Fichier de couverture généré par `bam_coverage`

    output:
        path "${coverage_bed.baseName}_low_coverage.bed"  // Fichier BED des régions à faible couverture

    script:
        """
        set -e  # Arrêter l'exécution en cas d'erreur

        # Filtrer les régions avec une couverture < 20
        awk '\$4 < 20 {print \$1, \$2, \$3}' ${coverage_bed} > ${coverage_bed.baseName}_low_coverage.bed
        """
}
