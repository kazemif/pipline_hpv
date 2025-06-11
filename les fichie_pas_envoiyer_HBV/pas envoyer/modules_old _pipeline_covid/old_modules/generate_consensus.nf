process generate_consensus {
    input:
    tuple val(barcode), path(vcf)

    output:
    path "result/${barcode}/${barcode}_consensus.fasta"

    script:
    """
    mkdir -p result/${barcode}
    bcftools consensus -f ${params.ref_genome} result/${barcode}/${barcode}_filtered.vcf.gz > result/${barcode}/${barcode}_consensus.fasta  #  Génération d'une séquence consensus basée sur les mutations détectées
    """
}

