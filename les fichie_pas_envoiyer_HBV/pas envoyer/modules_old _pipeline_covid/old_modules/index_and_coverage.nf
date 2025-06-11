process index_and_coverage {
    input:
    path bam_file     // Fichier BAM non trie
    path ref_genome   // Reference du genome

    output:
    
    path "${bam_file.baseName}.coverage.txt"

    script:
    """
   

    # etape 3 : Calculer la couverture avec la reference du genome
    bedtools genomecov -bg -ibam ${bam_file.baseName}.sorted.bam -g ${ref_genome} > ${bam_file.baseName}.coverage.txt
    """
}




