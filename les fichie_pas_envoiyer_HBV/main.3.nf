// Activer DSL2 de Nextflow
nextflow.enable.dsl=2

// Modules imports
include { merge_fastq } from "./modules/merge_fastq"
include { trim_reads } from './modules/trim_reads.nf'
include { parse_fastq_qc } from './modules/parse_fastq_qc.nf'
include { mapping_bam } from "./modules/mapping_bam.nf"
include { parse_bam_qc } from './modules/parse_bam_qc.nf'
include { bam_indexing } from "./modules/bam_indexing.nf"
include { bam_coverage } from './modules/bam_coverage.nf'
include { low_coverage_filtering } from './modules/low_coverage_filtering.nf'
include { variant_calling } from './modules/variant_calling.nf'
include { parse_variant_qc } from './modules/parse_variant_qc.nf'
include { consensus_generation } from './modules/consensus_generation.nf'



// Definition des parametres globaux
params.fastq_dir = "/home/etudiant/fatemeh/hbv_pipeline/data_test"  // Fichiers FASTQ

params.ref_genome = "/home/etudiant/fatemeh/hbv_pipeline/Ref/sequence.fasta"  // Reference genomique
params.result_dir = "/home/etudiant/fatemeh/hbv_pipeline/result/"  // Repertoire de sortie


//Adapters
params.adapter = "/home/etudiant/fatemeh/hbv_pipeline/primer/HBV_primer.fasta"

//Trimming option
params.min_len = 150
params.max_len = 1200
params.min_qual = 10

//Computing option
params.cpu = 10


         

workflow {
    // Charger les fichiers FASTQ
    fastq_ch = Channel.fromPath("${params.fastq_dir}/*.fastq.gz").collect()

    // Étapes de prétraitement
    merged_fastq_ch = merge_fastq(fastq_ch, params.sample_name)
    trimmed_fastq_ch = trim_reads(merged_fastq_ch, params.adapter, params.min_len, params.max_len, params.min_qual, params.cpu)

     // Étape 1 : Analyse de qualité des fichiers FASTQ**********************
    parce_fastq_qc_ch = parse_fastq_qc(fastq_ch)  parse_fastq_qc

    // Étape  2 : Mapping avec Minimap2 + tri BAM
    mapped_bam_ch = mapping_bam(trimmed_fastq_ch, params.ref_genome)

    // Étape 3 : Analyse des fichiers BAM*************************
 parse_bam_qc = parse_bam_qc _bam_qc(mapped_bam_ch)

    // Étape 4 : Indexation du BAM (obligatoire pour appel de variants)
    bam_outputs = bam_indexing(mapped_bam_ch)
    indexed_bam_ch = bam_outputs[0]
    indexed_bai_ch = bam_outputs[1]

    // Étape 5 : Calcul de la couverture (utilise BAM trié, PAS indexé)
    coverage_bed_ch = bam_coverage(mapped_bam_ch, params.ref_genome)  // Génère `.coverage.bed`

    // Étape 6 : Filtrage des régions à faible couverture
    low_coverage_bed_ch = low_coverage_filtering(coverage_bed_ch)  // Prend `.coverage.bed` en entrée

    // Étape 7 : Variant calling + compression + indexation
    vcf_outputs = variant_calling(indexed_bam_ch, indexed_bai_ch, params.ref_genome)
    vcf_gz_ch = vcf_outputs[0]  // `.vcf.gz`
    vcf_tbi_ch = vcf_outputs[1] // `.vcf.gz.tbi`

    //Étape 8 : Analyse des variants*************************************
    parse_variant_qc_ch = parse_variant_qc(vcf_gz_ch, indexed_bam_ch, params.ref_genome)

    // Étape 9 : Génération du consensus
    consensus_fasta_ch = consensus_generation(vcf_gz_ch, vcf_tbi_ch, params.ref_genome, low_coverage_bed_ch)
}

