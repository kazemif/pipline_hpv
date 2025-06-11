workflow {
    // Charger les fichiers FASTQ
    fastq_ch = Channel.fromPath("${params.fastq_dir}/*.fastq.gz").collect()

    // Étape 1 : Analyse de qualité des fichiers FASTQ
    fastq_qc_ch = fastq_qc(fastq_ch)

    // Étape 2 : Merge et Trim des reads
    merged_fastq_ch = merge_fastq(fastq_ch, params.sample_name)
    trimmed_fastq_ch = trim_reads(merged_fastq_ch, params.adapter, params.min_len, params.max_len, params.min_qual, params.cpu)

    // Étape 3 : Mapping avec Minimap2 + tri BAM
    mapped_bam_ch = mapping_bam(trimmed_fastq_ch, params.ref_genome)

    // Étape 4 : Analyse des fichiers BAM
    bam_qc_ch = bam_qc(mapped_bam_ch)

    // Étape 5 : Indexation du BAM
    bam_outputs = bam_indexing(mapped_bam_ch)
    indexed_bam_ch = bam_outputs[0]
    indexed_bai_ch = bam_outputs[1]

    // Étape 6 : Variant calling
    vcf_outputs = variant_calling(indexed_bam_ch, indexed_bai_ch, params.ref_genome)
    vcf_gz_ch = vcf_outputs[0]
    vcf_tbi_ch = vcf_outputs[1]

    // Étape 7 : Analyse des variants
    variant_qc_ch = variant_qc(vcf_gz_ch, indexed_bam_ch, params.ref_genome)

    // Étape 8 : Génération du consensus
    consensus_fasta_ch = consensus_generation(vcf_gz_ch, vcf_tbi_ch, params.ref_genome, low_coverage_bed_ch)
}
