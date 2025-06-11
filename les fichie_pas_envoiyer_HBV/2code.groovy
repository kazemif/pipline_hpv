nextflow.enable.dsl=2//////////////////////////////////////////////////////***********************************

// ========== MODULES ==========
include { decompress_archive } from './modules/decompress_archive.nf'
include { merge_fastq }        from './modules/merge_fastq.nf'
include { trim_reads }         from './modules/trim_reads.nf'
include { parse_fastq_qc }     from './modules/parse_fastq_qc.nf'
include { mapping_bam }   from './modules/mapping_bam.nf'
include { bam_indexing }  from './modules/bam_indexing.nf'
include { bam_coverage }           from './modules/bam_coverage.nf'
//include { low_coverage_filtering } from './modules/low_coverage_filtering.nf'
//include { variant_calling }        from './modules/variant_calling.nf'
//include { parse_variant_qc }         from './modules/parse_variant_qc.nf'
//include { consensus_generation }     from './modules/consensus_generation.nf'



// ========== PARAMÈTRES ==========
params.input        = null
params.sample       = null
params.adapter      = "/home/etudiant/fatemeh/hbv_pipeline/primer/HBV_primer.fasta"
params.ref_genome   = "/home/etudiant/fatemeh/hbv_pipeline/Ref/sequence.fasta"  // Reference genomique
params.result_dir   = "./results"
params.min_len      = 150
params.max_len      = 1200
params.min_qual     = 10
params.cpu          = 4

// ========== WORKFLOW PRINCIPAL ==========
workflow {

    // ✅ Vérifie que --input est fourni
    if (params.input == null) {
        error "❌ Vous devez fournir --input"
    }

    // ✅ Définit une valeur par défaut si result_dir n’est pas passé
    params.result_dir = params.result_dir ?: "./results"


    def input_file = file(params.input)

    // ======== CAS 1 : Archive compressée (.tar.gz, .zip, .gz) ========
    if (input_file.name.endsWith(".tar.gz") || input_file.name.endsWith(".zip") || input_file.name.endsWith(".gz")) {
        println "🔹 Archive compressée détectée"

        Channel
            .of(input_file)
            .set { archive_ch }

        decompress_archive(archive_ch)
            .map { file("decompressed") }
            .set { real_input_dir }

        // Détection plat ou multiplex après décompression
        real_input_dir
            .map { folder ->
                def is_multiplex = folder.list().any { file("${folder}/${it}").isDirectory() }

                if (is_multiplex) {
                    println "🔹 Dossier multiplex détecté"
                    def all_files = file("${folder}/*/*.fastq.gz").collect()
                    def grouped = all_files.groupBy { it.parent.name }
                    return grouped.collect { name, list -> tuple(name, list.sort()) }
                } else {
                    println "🔹 Dossier plat détecté"
                    def files = file("${folder}/*.fastq.gz").collect()
                    return [tuple("sample", files.sort())]
                }
            }
            .flatten()
            .set { fastq_ch }
    }

    // ======== CAS 2 : Dossier plat (fichiers uniquement) ========
    else if (
        input_file.isDirectory() &&
        !input_file.list().any { file("${params.input}/${it}").isDirectory() }
    ) {
        println "🔹 Dossier plat détecté"

        def files = file("${params.input}/*.fastq.gz").collect()
        Channel
            .of(tuple("sample", files.sort()))
            .set { fastq_ch }
    }

    // ======== CAS 3 : Dossier multiplex (avec sous-dossiers) ========
    else if (
        input_file.isDirectory() &&
        input_file.list().any { file("${params.input}/${it}").isDirectory() }
    ) {
        println "🔹 Dossier multiplex détecté"

        def all_files = file("${params.input}/*/*.fastq.gz").collect()
        def grouped = all_files.groupBy { it.parent.name }
        def all_tuples = grouped.collect { name, list -> tuple(name, list.sort()) }

        Channel
            .from(all_tuples)
            .set { fastq_ch }
    }

    // ======== CAS 4 : Fichier FASTQ unique ========
    else if (input_file.name.endsWith(".fastq.gz")) {
        println "🔹 Fichier FASTQ unique détecté"

        def sample_name = params.sample ?: input_file.baseName

        Channel
            .of(tuple(sample_name, [input_file]))
            .set { fastq_ch }
    }

    // ======== ERREUR : Chemin invalide ========
    else {
        error "❌ Chemin invalide ou format non supporté : ${params.input}"
    }

    // ========== PIPELINE BIOINFORMATIQUE ==========


    merged_fastq_ch = merge_fastq(fastq_ch) 


    trimmed_fastq_ch = trim_reads(
        merged_fastq_ch,
        file(params.adapter),
        params.min_len,
        params.max_len,
        params.min_qual,
        params.cpu
    )

    parse_fastq_qc(trimmed_fastq_ch)

    mapped_bam_ch = mapping_bam(
    trimmed_fastq_ch,
    file(params.ref_genome),
    params.cpu
)

indexed_bam_ch = bam_indexing(mapped_bam_ch)

// 1. Calcul de couverture
coverage_ch = bam_coverage(
    mapped_bam_ch.map { id, bam -> bam },
    file(params.ref_genome)
)

// 2. Filtrage des régions à faible couverture

//lowcov_ch = low_coverage_filtering(coverage_ch)     
 




}
////////////////////////////////////////////////*********************************************




process fastq_qc {
    tag "$sample_name"

    input:
    path fastq_file from fastq_ch
    val sample_name from params.sample_name

    output:
    path "${params.result_dir}/${sample_name}_fastq_qc/"

    script:
    """
    mkdir -p ${params.result_dir}/${sample_name}_fastq_qc
    parse_fastq -i $fastq_file -o ${params.result_dir}/${sample_name}_fastq_qc -c ${params.cpu}

    """
}


/////////////***********

process low_coverage_filtering {
    input:
        path coverage_bed

    output:
        path "${coverage_bed.baseName}_low_coverage.bed"

    publishDir "${params.result_dir ?: './results'}/${simpleName}", mode: 'copy'

    script:
    """
    awk '\$4 < 20 {print \$1, \$2, \$3}' ${coverage_bed} > ${coverage_bed.baseName}_low_coverage.bed
    """
}






process consensus_generation {

    input:
    tuple val(sample_id), path(vcf_file), path(vcf_index)
    path ref_genome
    path lowcov_bed

    output:
    path("${sample_id}_tmp.fa")
    path("${sample_id}_consensus.fasta")

    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    set -e

    # Étape 1 : Appliquer les variants
    bcftools consensus -f ${ref_genome} ${vcf_file} > ${sample_id}_tmp.fa

    # Étape 2 : Masquer les régions à faible couverture
    bedtools maskfasta -fi ${sample_id}_tmp.fa -bed ${lowcov_bed} -fo ${sample_id}_consensus.fasta
    """
}


process consensus_generation {

    input:
    tuple val(sample_id), path(vcf_file), path(vcf_index), path(ref_genome), path(lowcov_bed)

    output:
    path("${sample_id}_tmp.fa")
    path("${sample_id}_consensus.fasta")

    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    set -e

    # Étape 1 : Appliquer les variants
    bcftools consensus -f ${ref_genome} ${vcf_file} > ${sample_id}_tmp.fa

    # Étape 2 : Masquer les régions à faible couverture
    bedtools maskfasta -fi ${sample_id}_tmp.fa -bed ${lowcov_bed} -fo ${sample_id}_consensus.fasta
    """
}











process consensus_generation {

    input:
    tuple val(sample_id), path(vcf), path(tbi), path(ref_genome), path(lowcov_bed)

    output:
    path("${sample_id}.consensus.fa")

    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    # Générer la séquence consensus et masquer les régions à faible couverture
    bcftools consensus -f ${ref_genome} ${vcf} | \\
    bedtools maskfasta -fi - -bed ${lowcov_bed} -fo ${sample_id}.consensus.fa
    """
}


process consensus_generation {

    input:
    tuple val(sample_id), path(vcf), path(tbi), path(ref_genome), path(lowcov_bed)

    output:
    path("${sample_id}.consensus.fa")

    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    set -e

    # Étape 1 : Générer une séquence consensus à partir du fichier VCF
    bcftools consensus -f ${ref_genome} ${vcf} > ${sample_id}.tmp.fa

    # Étape 2 : Masquer les régions de faible couverture (remplace les bases par N)
    bedtools maskfasta -fi ${sample_id}.tmp.fa -bed ${lowcov_bed} -fo ${sample_id}.consensus.fa

  
    """
}





////////////////////////***********
process consensus_generation {

    input:
    tuple val(sample_id), path(vcf), path(tbi), path(ref_genome), path(lowcov_bed)

    output:
    path("${sample_id}.consensus.fa")

    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    set -e

    # Étape 1 : Générer le consensus à partir du VCF
    bcftools consensus -f ${ref_genome} ${vcf} > ${sample_id}.tmp.fa

    # Étape 2 : Masquer les régions à faible couverture avec bedtools
    bedtools maskfasta -fi ${sample_id}.tmp.fa -bed ${lowcov_bed} -fo ${sample_id}.consensus.fa

    rm ${sample_id}.tmp.fa
    """
}