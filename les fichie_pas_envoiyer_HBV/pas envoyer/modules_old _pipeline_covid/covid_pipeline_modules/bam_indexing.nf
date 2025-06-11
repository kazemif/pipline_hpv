process bam_indexing {
    input:
        path sorted_bam  // Fichier BAM trié

    output:
        path "${sorted_bam}"  // BAM trié indexé
        path "${sorted_bam}.bai"  // Fichier index BAM

    script:
        """
        set -e
        samtools index ${sorted_bam}
        """
}
