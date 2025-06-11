process mapping_bam {
    input:
        path trimmed_fastq   // Fichier FASTQ.gz après trimming
        path ref_genome      // Référence du génome

    output:
        path "${trimmed_fastq.baseName}.sorted.bam"  // Fichier BAM trié en sortie

    script:
        """
        set -e  # Arrêter l'exécution en cas d'erreur

        # Extraire le nom de l'échantillon (sans l'extension .fastq.gz)
        sample_name="${trimmed_fastq.baseName}"

        # Exécuter Minimap2 et convertir la sortie en BAM trié
        minimap2 -ax map-ont ${ref_genome} ${trimmed_fastq} | \
        samtools view -Sb - | \
        samtools sort -o \${sample_name}.sorted.bam
        """
}
