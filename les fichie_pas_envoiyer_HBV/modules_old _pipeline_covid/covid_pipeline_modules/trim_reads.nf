process trim_reads {
    input:
    path in_fastq       // Fichier FASTQ en entrée (provenant de merge_fastq)
    path in_adapter     // Fichier des adaptateurs
    val min_len
    val max_len
    val min_qual
    val cpu

    output:
    path "*_trim_reads.fastq.gz"

    script:
    """
    # Extraire le nom de l'échantillon sans l'extension
    sample_name=\$(basename ${in_fastq} | sed 's/.fastq.gz//')

    # Exécuter cutadapt pour le trimming
    cutadapt -j ${cpu} \\
        -a file:${in_adapter} \\
        --discard-untrimmed \\
        -m ${min_len} \\
        -M ${max_len} \\
        -q ${min_qual} \\
        -o \${sample_name}_trim_reads.fastq.gz \\
        ${in_fastq}
    """
}

