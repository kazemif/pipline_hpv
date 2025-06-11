params {
  params.result_dir = params.result_dir ?: "./results"
  adapter = "/home/etudiant/fatemeh/hbv_pipeline/primer/HBV_primer.fasta"
  ref_genome = "/home/etudiant/fatemeh/hbv_pipeline/Ref/sequence.fasta"  // Reference genomique
  min_len = 150
  max_len = 1200
  min_qual = 10
  cpu = 4
}





////////////////////////########## important 
process mapping_bam {
    input:
    tuple val(sample_id), path(trimmed_fastq)
    path ref_genome
    val cpu

    output:
    tuple val(sample_id), path("${sample_id}.sorted.bam")

    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    minimap2 -ax map-ont ${ref_genome} ${trimmed_fastq} | \\
    samtools view -Sb - | \\
    samtools sort -o ${sample_id}.sorted.bam
    """
}




/////////////////////

process mapping_bam {
    tag "$sample_id"

    input:
    tuple val(sample_id), path(trimmed_fastq)
    path ref_genome
    val cpu

    output:
    tuple val(sample_id), path("${sample_id}.sorted.bam"), path("${sample_id}.sam")

    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    # 1. Mapping ➜ SAM
    minimap2 -ax map-ont ${ref_genome} ${trimmed_fastq} > ${sample_id}.sam

    # 2. SAM ➜ BAM trié
    samtools view -Sb ${sample_id}.sam | samtools sort -o ${sample_id}.sorted.bam
    """
}



process mapping_bam {
    input:
    tuple val(sample_id), path(trimmed_fastq)
    path ref_genome
    val cpu

    output:
    tuple val(sample_id), path("${sample_id}.sorted.bam"), path("${sample_id}.sam")

    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    # Étape 1 : Générer un fichier .sam pour parse_read_align
    minimap2 -ax map-ont ${ref_genome} ${trimmed_fastq} > ${sample_id}.sam

    # Étape 2 : Convertir .sam en .bam
    samtools view -Sb ${sample_id}.sam > ${sample_id}.bam

    # Étape 3 : Trier .bam en .sorted.bam
    samtools sort ${sample_id}.bam -o ${sample_id}.sorted.bam

    # Remarque : on ne supprime PAS le .sam (il sera utilisé par parse_read_align)
    """
}




*****************************************************important 
process parse_read_align {
    tag "${sample_id}"

    input:
    tuple val(sample_id), path(sorted_bam), path(sam_file)

    output:
    path "output_${sample_id}/*.txt" // accepte les fichiers .txt générés

    publishDir "${params.result_dir}/${sample_id}/read_alignment_stats", mode: 'copy'

    script:
    """
    echo "🔍 Analyse de ${sample_id}"

    mkdir -p output_${sample_id}

    python3 ${params.bam_qc_script} \\
        -i "${sam_file}" \\
        -o output_${sample_id} \\
        -s "${sample_id}" || true
    """
}




////////////////////////////////////***********impoetant ca fonction avant 

process bam_indexing {
    input:
    tuple val(sample_id), path(sorted_bam)

    output:
    tuple val(sample_id), path("${sorted_bam}.bai")

    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    samtools index ${sorted_bam}
    """
}


************************
 ///indexed_bam_ch = bam_indexing(mapped_bam_ch)

   // coverage_ch = bam_coverage(mapped_bam_ch.map { id, bam -> bam }, file(params.ref_genome))
