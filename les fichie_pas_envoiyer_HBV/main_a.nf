nextflow.enable.dsl=2

// ========== MODULES ==========
include { decompress_archive }     from './modules/decompress_archive.nf'
include { merge_fastq }            from './modules/merge_fastq.nf'
include { trim_reads }             from './modules/trim_reads.nf'
include { parse_fastq_qc }         from './modules/parse_fastq_qc.nf'
include { mapping_bam }            from './modules/mapping_bam.nf'
include { parse_read_align }       from './modules/parse_read_align.nf'  
include { bam_indexing }           from './modules/bam_indexing.nf'
include { bam_coverage }           from './modules/bam_coverage.nf'
include { low_coverage_filtering } from './modules/low_coverage_filtering.nf'
include { variant_calling }        from './modules/variant_calling.nf'
include { parse_variant_qc } from './modules/parse_variant_qc.nf'
include { consensus_generation } from './modules/consensus_generation.nf'


//include { consensus_generation }   from './modules/consensus_generation.nf'
 


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






def detect_input_type(path) {
    def input_path = file(path)

    if (input_path.name.endsWith('.tar.gz') || input_path.name.endsWith('.zip') || input_path.name.endsWith('.gz')) {
        return decompress_archive(Channel.of(input_path))
            .map { file("decompressed") }
            .map { folder ->
                def subdirs = folder.list().findAll { file("${folder}/${it}").isDirectory() }
                if (subdirs) {
                    println "🔹 Dossier multiplex détecté après décompression"
                    def grouped = file("${folder}/*/*.fastq.gz").groupBy { it.parent.name }
                    grouped.collect { name, list -> tuple(name, list.sort()) }
                } else {
                    println "🔹 Dossier plat détecté après décompression"
                    [ tuple("sample", file("${folder}/*.fastq.gz").sort()) ]
                }
            }
            .flatten()
    }

    else if (input_path.isDirectory() && !input_path.list().any { file("${params.input}/${it}").isDirectory() }) {
        println "🔹 Dossier plat détecté"
        def files = file("${params.input}/*.fastq.gz").sort()
        return Channel.of(tuple("sample", files))
    }

    else if (input_path.isDirectory() && input_path.list().any { file("${params.input}/${it}").isDirectory() }) {
        println "🔹 Dossier multiplex détecté"
        def grouped = file("${params.input}/*/*.fastq.gz").groupBy { it.parent.name }
        def tuples = grouped.collect { name, list -> tuple(name, list.sort()) }
        return Channel.from(tuples)
    }

    else if (input_path.name.endsWith('.fastq.gz')) {
        println "🔹 Fichier unique FASTQ détecté"
        def sample_name = params.sample ?: input_path.baseName
        return Channel.of(tuple(sample_name, [input_path]))
    }

    else {
        error "❌ Chemin d’entrée invalide ou non supporté : ${params.input}"
    }
}


workflow {
    fastq_ch = detect_input_type(params.input)

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

    mapped_bam_ch = mapping_bam(trimmed_fastq_ch, file(params.ref_genome), params.cpu)

    parse_read_align(mapped_bam_ch)     


    indexed_bam_ch = bam_indexing(mapped_bam_ch)

    coverage_ch = bam_coverage(mapped_bam_ch.map { id, bam -> bam }, file(params.ref_genome))

  ///lowcov_ch = low_coverage_filtering(
    //coverage_ch.map { file -> 
     //   def sample_id = file.simpleName.replace('.sorted.coverage', '')
      //  tuple(sample_id, file)
    //}
//)


//variant_input_ch = mapped_bam_ch
    //.join(indexed_bam_ch)
  //  .map { id, bam, bai -> tuple(id, bam, bai) }

//variant_ch = variant_calling(variant_input_ch, file(params.ref_genome))







//consensus_input_ch = variant_ch
    //.join(lowcov_ch)
    //.map { sample_id, vcf, tbi, bed ->
    //    tuple(sample_id, vcf, tbi, file(params.ref_genome), bed)
  //  }

//consensus_fa_ch = consensus_generation(consensus_input_ch)







// Créer lowcov_ch avec un bon sample_id
lowcov_ch = coverage_ch.map { file ->
    def sample_id = file.simpleName.tokenize('.')[0]  // Extrait "barcode01" de "barcode01.low_coverage.bed"
    tuple(sample_id, file)
}

// Créer variant_input_ch
variant_input_ch = mapped_bam_ch
    .join(indexed_bam_ch)
    .map { id, bam, bai -> tuple(id, bam, bai) }

variant_ch = variant_calling(variant_input_ch, file(params.ref_genome))


variant_qc_ch = parse_variant_qc(
   variant_ch.map { sample_id, vcf_file, _ -> tuple(sample_id, vcf_file) }

)

// Créer consensus_input_ch en joignant les VCF avec les fichiers .bed
consensus_input_ch = variant_ch
    .join(lowcov_ch)
    .map { sample_id, vcf, tbi, bed ->
        tuple(sample_id, vcf, tbi, file(params.ref_genome), bed)
    }

// Lancer le module consensus
consensus_fa_ch = consensus_generation(consensus_input_ch)







}
