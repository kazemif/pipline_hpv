process align_minimap {
    input:
        path trimmed_fastq // Fichier FASTQ.gz après trimming
        path ref_genome    // Référence du génome

    output:
        path "*.bam"       // Fichier BAM en sortie

    script:
        """
        # Extraire le nom de l'échantillon (sans l'extension .fastq.gz)
        sample_name=\$(basename ${trimmed_fastq} | sed 's/.fastq.gz//')

        echo "Alignement avec Minimap2 en cours pour \$sample_name"

        # Exécuter Minimap2 pour l'alignement
        minimap2 -ax map-ont ${ref_genome} ${trimmed_fastq} | \\
        samtools view -Sb - > \${sample_name}.bam

        echo "Alignement terminé : \${sample_name}.bam"
        """
}

