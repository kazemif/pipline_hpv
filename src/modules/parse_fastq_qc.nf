process parse_fastq_qc {

    input:
    tuple val(sample_id), path(trimmed_fastq)

    output:
    path("${sample_id}_qc.txt")

    // ✅ Sécurisé avec fallback : si params.result_dir est null, utiliser "./results"
    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    echo 'Fichier : ${trimmed_fastq}' > ${sample_id}_qc.txt
    echo 'Nombre de lignes :' >> ${sample_id}_qc.txt
    zcat ${trimmed_fastq} | wc -l >> ${sample_id}_qc.txt
    echo 'Taille fichier :' >> ${sample_id}_qc.txt
    du -h ${trimmed_fastq} >> ${sample_id}_qc.txt
    """
}

