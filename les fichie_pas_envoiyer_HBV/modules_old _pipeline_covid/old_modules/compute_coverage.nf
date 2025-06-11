process compute_coverage {
    input:
    path sorted_bam // Fichier BAM trié (sans .bai)
    path ref_genome // Référence du génome

    output:
    path "${sorted_bam.baseName}.coverage.txt" // Fichier de sortie contenant la couverture

    script:
    """
    bedtools genomecov -bg -ibam ${sorted_bam} > ${sorted_bam.baseName}.coverage.txt
    """
}
