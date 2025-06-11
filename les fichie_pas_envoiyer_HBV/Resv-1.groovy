// Activer DSL2 de Nextflow
//nextflow.enable.dsl=2

// Modules imports
//include { merge_fastq } from "./modules/merge_fastq"
//include { trim_reads } from './modules/trim_reads.nf'
//include { parse_fastq_qc } from './modules/parse_fastq_qc.nf'
//include { mapping_bam } from "./modules/mapping_bam.nf"
//include { parse_bam_qc } from './modules/parse_bam_qc.nf'
//include { bam_indexing } from "./modules/bam_indexing.nf"
//include { bam_coverage } from './modules/bam_coverage.nf'
//include { low_coverage_filtering } from './modules/low_coverage_filtering.nf'
//include { variant_calling } from './modules/variant_calling.nf'
//include { parse_variant_qc } from './modules/parse_variant_qc.nf'
//include { consensus_generation } from './modules/consensus_generation.nf'



// Definition des parametres globaux
//params.fastq_dir = "/home/etudiant/fatemeh/hbv_pipeline/data_test"  // Fichiers FASTQ

//params.ref_genome = "/home/etudiant/fatemeh/hbv_pipeline/Ref/sequence.fasta"  // Reference genomique
//params.result_dir = "/home/etudiant/fatemeh/hbv_pipeline/result/"  // Repertoire de sortie


//Adapters
//params.adapter = "/home/etudiant/fatemeh/hbv_pipeline/primer/HBV_primer.fasta"

//Trimming option
//params.min_len = 150
//params.max_len = 1200
//params.min_qual = 10

//Computing option
//params.cpu = 10


         

//workflow {
    // Charger les fichiers FASTQ
  //  fastq_ch = Channel.fromPath("${params.fastq_dir}/*.fastq.gz").collect()

    // Étapes de prétraitement
    //merged_fastq_ch = merge_fastq(fastq_ch, params.sample_name)
    //trimmed_fastq_ch = trim_reads(merged_fastq_ch, params.adapter, params.min_len, params.max_len, params.min_qual, params.cpu)

     // Étape 1 : Analyse de qualité des fichiers FASTQ**********************
    //parce_fastq_qc_ch = parse_fastq_qc(fastq_ch)  parse_fastq_qc

    // Étape  2 : Mapping avec Minimap2 + tri BAM
    //mapped_bam_ch = mapping_bam(trimmed_fastq_ch, params.ref_genome)

    // Étape 3 : Analyse des fichiers BAM*************************
 //parse_bam_qc = parse_bam_qc _bam_qc(mapped_bam_ch)

    // Étape 4 : Indexation du BAM (obligatoire pour appel de variants)
    //bam_outputs = bam_indexing(mapped_bam_ch)
    //indexed_bam_ch = bam_outputs[0]
    ///indexed_bai_ch = bam_outputs[1]

    // Étape 5 : Calcul de la couverture (utilise BAM trié, PAS indexé)
    //coverage_bed_ch = bam_coverage(mapped_bam_ch, params.ref_genome)  // Génère `.coverage.bed`

    // Étape 6 : Filtrage des régions à faible couverture
    //low_coverage_bed_ch = low_coverage_filtering(coverage_bed_ch)  // Prend `.coverage.bed` en entrée

    // Étape 7 : Variant calling + compression + indexation
    //vcf_outputs = variant_calling(indexed_bam_ch, indexed_bai_ch, params.ref_genome)
    //vcf_gz_ch = vcf_outputs[0]  // `.vcf.gz`
    //vcf_tbi_ch = vcf_outputs[1] // `.vcf.gz.tbi`

    //Étape 8 : Analyse des variants*************************************
    //parse_variant_qc_ch = parse_variant_qc(vcf_gz_ch, indexed_bam_ch, params.ref_genome)

    // Étape 9 : Génération du consensus
    //consensus_fasta_ch = consensus_generation(vcf_gz_ch, vcf_tbi_ch, params.ref_genome, low_coverage_bed_ch)
//}








//nextflow.enable.dsl=2

// ===== Modules imports =====
//include { merge_fastq }            from './modules/merge_fastq.nf'
//include { trim_reads }             from './modules/trim_reads.nf'
//include { parse_fastq_qc }         from './modules/parse_fastq_qc.nf'
//include { mapping_bam }            from './modules/mapping_bam.nf'
//include { parse_bam_qc }           from './modules/parse_bam_qc.nf'
//include { bam_indexing }           from './modules/bam_indexing.nf'
//include { bam_coverage }           from './modules/bam_coverage.nf'
//include { low_coverage_filtering } from './modules/low_coverage_filtering.nf'
//include { variant_calling }        from './modules/variant_calling.nf'
//include { parse_variant_qc }      from './modules/parse_variant_qc.nf'
//include { consensus_generation }   from './modules/consensus_generation.nf'

// ===== Paramètres =====
//params.fastq_dir = "/home/etudiant/fatemeh/hbv_pipeline/data_test"
//params.result_dir = "/home/etudiant/fatemeh/hbv_pipeline/result/"
//params.ref_genome = "/home/etudiant/fatemeh/hbv_pipeline/Ref/sequence.fasta"
//params.adapter = "/home/etudiant/fatemeh/hbv_pipeline/primer/HBV_primer.fasta"
//params.min_len = 150
//params.max_len = 1200
//params.min_qual = 10
//params.cpu = 10

//workflow {

    // === Détection automatique du type d'entrée ===
   // if (file(params.fastq_dir).isDirectory()) {
      //  def files = file(params.fastq_dir).listFiles().findAll { it.name.endsWith('.fastq') || it.name.endsWith('.fastq.gz') }

      //  if (files.every { it.isFile() }) {
          //  println "🔹 Dossier plat détecté"
         //   fastq_ch = Channel.fromFilePairs("${params.fastq_dir}/*.{fastq,fastq.gz}", flat: true)
       // } 
       // else {
         //   println "🔹 Dossier multiplex (barcodes) détecté"
       //     fastq_ch = Channel.fromFilePairs("${params.fastq_dir}/*/*.fastq", flat: true)
     //   }
   // } 
   // else {
    //    error "❌ Le chemin dans params.fastq_dir n'est pas valide"
   // }

    // === Étape 1 : Merge FASTQ ===
   // merged_fastq_ch = merge_fastq(fastq_ch)

    // === Étape 2 : Trimming ===
   // trimmed_fastq_ch = trim_reads(
      //  merged_fastq_ch,
      //  params.adapter,
      //  params.min_len,
      //  params.max_len,
     //   params.min_qual,
     //   params.cpu
   // )

    // === Étape 3 : Analyse qualité FASTQ ===
   // fastq_qc_ch = parse_fastq_qc(merged_fastq_ch)

    // === Étape 4 : Mapping ===
   // mapped_bam_ch = mapping_bam(trimmed_fastq_ch, params.ref_genome)

    // === Étape 5 : Analyse BAM ===
   // bam_qc_ch = parse_bam_qc(mapped_bam_ch)

    // === Étape 6 : Indexation BAM ===
   // bam_index_outputs = bam_indexing(mapped_bam_ch)
   // indexed_bam_ch = bam_index_outputs[0]
   // indexed_bai_ch = bam_index_outputs[1]

    // === Étape 7 : Couverture BAM ===
  //  coverage_bed_ch = bam_coverage(mapped_bam_ch, params.ref_genome)

    // === Ensuite : filtering, variant calling, etc. ===
//}












nextflow.enable.dsl=2

// ===== Modules imports =====
include { merge_fastq }            from './modules/merge_fastq.nf'
include { trim_reads }             from './modules/trim_reads.nf'
include { parse_fastq_qc }         from './modules/parse_fastq_qc.nf'
//include { mapping_bam }            from './modules/mapping_bam.nf'
//include { parse_bam_qc }           from './modules/parse_bam_qc.nf'
//include { bam_indexing }           from './modules/bam_indexing.nf'
//include { bam_coverage }           from './modules/bam_coverage.nf'
//include { low_coverage_filtering } from './modules/low_coverage_filtering.nf'
//include { variant_calling }        from './modules/variant_calling.nf'
//include { parse_variant_qc }      from './modules/parse_variant_qc.nf'
//include { consensus_generation }   from './modules/consensus_generation.nf'

// ===== Paramètres =====
params.fastq = null
params.sample = null
params.ref_genome = "/home/etudiant/fatemeh/hbv_pipeline/Ref/sequence.fasta"
params.adapter = "/home/etudiant/fatemeh/hbv_pipeline/primer/HBV_primer.fasta"
params.min_len = 150
params.max_len = 1200
params.min_qual = 10
params.cpu = 10

workflow {

    // === Détection automatique du type d'entrée ===
    if (file(params.fastq).isFile()) {
        println "🔹 Fichier unique détecté"
        fastq_ch = Channel.of([params.sample ?: "sample1", file(params.fastq)])
    }
    else if (file(params.fastq).isDirectory()) {
        def files = file(params.fastq).listFiles().findAll { it.name.endsWith('.fastq') || it.name.endsWith('.fastq.gz') }

        if (files.every { it.isFile() }) {
            println "🔹 Dossier plat détecté"
            fastq_ch = Channel.fromFilePairs("${params.fastq}/*.{fastq,fastq.gz}", flat: true)
        } 
        else {
            println "🔹 Dossier multiplex détecté"
            fastq_ch = Channel.fromFilePairs("${params.fastq}/*/*.fastq", flat: true)
        }
    } 
    else {
        error "❌ Le chemin donné avec --fastq n'est pas valide"
    }

    // === Étape 1 : Merge FASTQ ===
    merged_fastq_ch = merge_fastq(fastq_ch)      


    // === Étape 2 : Trimming ===
    trimmed_fastq_ch = trim_reads(
        merged_fastq_ch,
        params.adapter,
        params.min_len,
        params.max_len,
        params.min_qual,
        params.cpu
    )

    // === Étape 3 : Analyse qualité FASTQ ===
    fastq_qc_ch = parse_fastq_qc(merged_fastq_ch)

    // === Étape 4 : Mapping ===
   // mapped_bam_ch = mapping_bam(trimmed_fastq_ch, params.ref_genome)

    // === Étape 5 : Analyse BAM ===
    //bam_qc_ch = parse_bam_qc(mapped_bam_ch)

    // === Étape 6 : Indexation BAM ===
  //  bam_index_outputs = bam_indexing(mapped_bam_ch)
//    indexed_bam_ch = bam_index_outputs[0]
//    indexed_bai_ch = bam_index_outputs[1]

    // === Étape 7 : Couverture BAM ===
    coverage_bed_ch = bam_coverage(mapped_bam_ch, params.ref_genome)

    // === Étape 8 : Filtering, Variant calling, QC Variant, Consensus
    filtered_bam_ch = low_coverage_filtering(coverage_bed_ch)
    variant_vcf_ch  = variant_calling(indexed_bam_ch, params.ref_genome)
    variant_qc_ch   = parse_variant_qc(variant_vcf_ch)
    consensus_fa_ch = consensus_generation(indexed_bam_ch, params.ref_genome)
}
nextflow.enable.dsl=2

// ===== Modules imports =====
include { merge_fastq }            from './modules/merge_fastq.nf'
//include { trim_reads }             from './modules/trim_reads.nf'
//include { parse_fastq_qc }         from './modules/parse_fastq_qc.nf'
//include { mapping_bam }            from './modules/mapping_bam.nf'
//include { parse_bam_qc }           from './modules/parse_bam_qc.nf'
//include { bam_indexing }           from './modules/bam_indexing.nf'
//include { bam_coverage }           from './modules/bam_coverage.nf'
//include { low_coverage_filtering } from './modules/low_coverage_filtering.nf'
//include { variant_calling }        from './modules/variant_calling.nf'
//include { parse_variant_qc }      from './modules/parse_variant_qc.nf'
//include { consensus_generation }   from './modules/consensus_generation.nf'

// ===== Paramètres =====
params.input = null
params.sample = null
params.ref_genome = "/home/etudiant/fatemeh/hbv_pipeline/Ref/sequence.fasta"
params.adapter = "/home/etudiant/fatemeh/hbv_pipeline/primer/HBV_primer.fasta"
params.min_len = 150
params.max_len = 1200
params.min_qual = 10
params.cpu = 10

workflow {

    if (params.input == null) {
        error "❌ Vous devez donner un chemin avec --input"
    }

    // Détection du type d'entrée
    if (file(params.input).isFile()) {
        if (params.input.endsWith('.fastq') || params.input.endsWith('.fastq.gz')) {
            println "🔹 Fichier FASTQ détecté"
            fastq_ch = Channel.of([params.sample ?: "sample1", file(params.input)])
        } else if (params.input.endsWith('.fasta')) {
            println "🔹 Fichier FASTA détecté"
            fasta_ch = Channel.of([params.sample ?: "sample1", file(params.input)])
        } else if (params.input.endsWith('.csv')) {
            println "🔹 Fichier CSV détecté"
            csv_ch = Channel.of(file(params.input))
        } else if (params.input.endsWith('.tar.gz')) {
            error "❗️ Archive détectée. Veuillez la décompresser avant de lancer le pipeline."
        } else {
            error "❌ Format de fichier non reconnu."
        }

    } else if (file(params.input).isDirectory()) {
        def files = file(params.input).listFiles()

        if (files.any { it.isDirectory() }) {
            println "🔹 Dossier multiplex détecté"
            fastq_ch = Channel.fromFilePairs("${params.input}/*/*.fastq", flat: true)
            fasta_ch = Channel.fromFilePairs("${params.input}/*/*.fasta", flat: true)
        } else if (files.any { it.name.endsWith('.fastq') || it.name.endsWith('.fastq.gz') }) {
            println "🔹 Dossier plat FASTQ détecté"
            fastq_ch = Channel.fromFilePairs("${params.input}/*.{fastq,fastq.gz}", flat: true)
        } else if (files.any { it.name.endsWith('.fasta') }) {
            println "🔹 Dossier plat FASTA détecté"
            fasta_ch = Channel.fromFilePairs("${params.input}/*.fasta", flat: true)
        } else {
            error "❌ Aucun fichier FASTQ, FASTA ou CSV trouvé."
        }
    } else {
        error "❌ Le chemin donné avec --input n'est pas valide"
    }

    // Charger les fichiers FASTQ
  //  fastq_ch = Channel.fromPath("${params.fastq_dir}/*.fastq.gz").collect()

    // Étapes de prétraitement
    //merged_fastq_ch = merge_fastq(fastq_ch, params.sample_name)
    //trimmed_fastq_ch = trim_reads(merged_fastq_ch, params.adapter, params.min_len, params.max_len, params.min_qual, params.cpu)

     // Étape 1 : Analyse de qualité des fichiers FASTQ**********************
    //parce_fastq_qc_ch = parse_fastq_qc(fastq_ch)  parse_fastq_qc

    // Étape  2 : Mapping avec Minimap2 + tri BAM
    //mapped_bam_ch = mapping_bam(trimmed_fastq_ch, params.ref_genome)

    // Étape 3 : Analyse des fichiers BAM*************************
 //parse_bam_qc = parse_bam_qc _bam_qc(mapped_bam_ch)

    // Étape 4 : Indexation du BAM (obligatoire pour appel de variants)
    //bam_outputs = bam_indexing(mapped_bam_ch)
    //indexed_bam_ch = bam_outputs[0]
    ///indexed_bai_ch = bam_outputs[1]

    // Étape 5 : Calcul de la couverture (utilise BAM trié, PAS indexé)
    //coverage_bed_ch = bam_coverage(mapped_bam_ch, params.ref_genome)  // Génère `.coverage.bed`

    // Étape 6 : Filtrage des régions à faible couverture
    //low_coverage_bed_ch = low_coverage_filtering(coverage_bed_ch)  // Prend `.coverage.bed` en entrée

    // Étape 7 : Variant calling + compression + indexation
    //vcf_outputs = variant_calling(indexed_bam_ch, indexed_bai_ch, params.ref_genome)
    //vcf_gz_ch = vcf_outputs[0]  // `.vcf.gz`
    //vcf_tbi_ch = vcf_outputs[1] // `.vcf.gz.tbi`

    //Étape 8 : Analyse des variants*************************************
    //parse_variant_qc_ch = parse_variant_qc(vcf_gz_ch, indexed_bam_ch, params.ref_genome)

    // Étape 9 : Génération du consensus
    //consensus_fasta_ch = consensus_generation(vcf_gz_ch, vcf_tbi_ch, params.ref_genome, low_coverage_bed_ch)
//}





nextflow.enable.dsl=2

// ===== Modules imports =====
include { merge_fastq }            from './modules/merge_fastq.nf'
include { trim_reads }             from './modules/trim_reads.nf'
include { parse_fastq_qc }         from './modules/parse_fastq_qc.nf'
include { mapping_bam }            from './modules/mapping_bam.nf'
include { parse_bam_qc }           from './modules/parse_bam_qc.nf'
include { bam_indexing }           from './modules/bam_indexing.nf'
include { bam_coverage }           from './modules/bam_coverage.nf'
include { low_coverage_filtering } from './modules/low_coverage_filtering.nf'
include { variant_calling }        from './modules/variant_calling.nf'
include { parse_variant_qc }      from './modules/parse_variant_qc.nf'
include { consensus_generation }   from './modules/consensus_generation.nf'

// ===== Paramètres =====
params.input = null
params.sample = null
params.ref_genome = "/home/etudiant/fatemeh/hbv_pipeline/Ref/sequence.fasta"
params.adapter = "/home/etudiant/fatemeh/hbv_pipeline/primer/HBV_primer.fasta"
params.min_len = 150
params.max_len = 1200
params.min_qual = 10
params.cpu = 10

workflow {

    if (params.input == null) {
        error "❌ Vous devez donner un chemin avec --input"
    }

    // Détection du type d'entrée
    if (file(params.input).isDirectory()) {
        def files = file(params.input).listFiles()

        if (files.any { it.isDirectory() }) {
            println "🔹 Dossier multiplex détecté"
            fastq_ch = Channel.fromFilePairs("${params.input}/*/*.fastq", flat: true)
        } else {
            error "❌ Aucun dossier multiplex détecté."
        }
    } else {
        error "❌ Le chemin donné avec --input n'est pas valide"
    }

    // Pipeline complet par barcode
    merged_fastq_ch = merge_fastq(fastq_ch)

    trimmed_fastq_ch = trim_reads(
        merged_fastq_ch,
        params.adapter,
        params.min_len,
        params.max_len,
        params.min_qual,
        params.cpu
    )

    fastq_qc_ch = parse_fastq_qc(merged_fastq_ch)

    mapped_bam_ch = mapping_bam(trimmed_fastq_ch, params.ref_genome)

    bam_qc_ch = parse_bam_qc(mapped_bam_ch)

    bam_index_outputs = bam_indexing(mapped_bam_ch)
    indexed_bam_ch = bam_index_outputs[0]
    indexed_bai_ch = bam_index_outputs[1]

    coverage_bed_ch = bam_coverage(mapped_bam_ch, params.ref_genome)

    filtered_bam_ch = low_coverage_filtering(coverage_bed_ch)

    variant_vcf_ch  = variant_calling(indexed_bam_ch, params.ref_genome)

    variant_qc_ch   = parse_variant_qc(variant_vcf_ch)

    consensus_fa_ch = consensus_generation(indexed_bam_ch, params.ref_genome)

    println "✅ Pipeline terminé pour tous les barcodes."
}






//////////////////////////////////////////

nextflow.enable.dsl=2

// ===== Modules imports =====
include { merge_fastq }            from './modules/merge_fastq.nf'
//include { trim_reads }             from './modules/trim_reads.nf'
//include { parse_fastq_qc }         from './modules/parse_fastq_qc.nf'
//include { mapping_bam }            from './modules/mapping_bam.nf'
//include { parse_bam_qc }           from './modules/parse_bam_qc.nf'
//include { bam_indexing }           from './modules/bam_indexing.nf'
//include { bam_coverage }           from './modules/bam_coverage.nf'
//include { low_coverage_filtering } from './modules/low_coverage_filtering.nf'
//include { variant_calling }        from './modules/variant_calling.nf'
//include { parse_variant_qc }      from './modules/parse_variant_qc.nf'
//include { consensus_generation }   from './modules/consensus_generation.nf'

// ===== Paramètres =====
params.input = null
params.sample = null
params.ref_genome = "/home/etudiant/fatemeh/hbv_pipeline/Ref/sequence.fasta"
params.adapter = "/home/etudiant/fatemeh/hbv_pipeline/primer/HBV_primer.fasta"
params.min_len = 150
params.max_len = 1200
params.min_qual = 10
params.cpu = 10

workflow {

    if (params.input == null) {
        error "❌ Vous devez donner un chemin avec --input"
    }

    // Détection du type d'entrée
    if (file(params.input).isFile()) {
        if (params.input.endsWith('.fastq') || params.input.endsWith('.fastq.gz')) {
            println "🔹 Fichier FASTQ détecté"
            fastq_ch = Channel.of([params.sample ?: "sample1", file(params.input)])
        } else if (params.input.endsWith('.fasta')) {
            println "🔹 Fichier FASTA détecté"
            fasta_ch = Channel.of([params.sample ?: "sample1", file(params.input)])
        } else if (params.input.endsWith('.csv')) {
            println "🔹 Fichier CSV détecté"
            csv_ch = Channel.of(file(params.input))
        } else if (params.input.endsWith('.tar.gz')) {
            error "❗️ Archive détectée. Veuillez la décompresser avant de lancer le pipeline."
        } else {
            error "❌ Format de fichier non reconnu."
        }

    } else if (file(params.input).isDirectory()) {
        def files = file(params.input).listFiles()

        if (files.any { it.isDirectory() }) {
            println "🔹 Dossier multiplex détecté"
            fastq_ch = Channel.fromFilePairs("${params.input}/*/*.fastq", flat: true)
            fasta_ch = Channel.fromFilePairs("${params.input}/*/*.fasta", flat: true)
        } else if (files.any { it.name.endsWith('.fastq') || it.name.endsWith('.fastq.gz') }) {
            println "🔹 Dossier plat FASTQ détecté"
            fastq_ch = Channel.fromFilePairs("${params.input}/*.{fastq,fastq.gz}", flat: true)
        } else if (files.any { it.name.endsWith('.fasta') }) {
            println "🔹 Dossier plat FASTA détecté"
            fasta_ch = Channel.fromFilePairs("${params.input}/*.fasta", flat: true)
        } else {
            error "❌ Aucun fichier FASTQ, FASTA ou CSV trouvé."
        }
    } else {
        error "❌ Le chemin donné avec --input n'est pas valide"
    }

    if (fastq_ch) {
        merged_fastq_ch = merge_fastq(fastq_ch)

        trimmed_fastq_ch = trim_reads(
            merged_fastq_ch,
            params.adapter,
            params.min_len,
            params.max_len,
            params.min_qual,
            params.cpu
        )

        fastq_qc_ch = parse_fastq_qc(merged_fastq_ch)

  //      mapped_bam_ch = mapping_bam(trimmed_fastq_ch, params.ref_genome)

        bam_qc_ch = parse_bam_qc(mapped_bam_ch)

        bam_index_outputs = bam_indexing(mapped_bam_ch)
        indexed_bam_ch = bam_index_outputs[0]
        indexed_bai_ch = bam_index_outputs[1]

        coverage_bed_ch = bam_coverage(mapped_bam_ch, params.ref_genome)

        filtered_bam_ch = low_coverage_filtering(coverage_bed_ch)

        variant_vcf_ch  = variant_calling(indexed_bam_ch, params.ref_genome)

        variant_qc_ch   = parse_variant_qc(variant_vcf_ch)

        consensus_fa_ch = consensus_generation(indexed_bam_ch, params.ref_genome)
    }
}




////////////

//process merge_fastq {
    //input:
        //path in_fastq
      //  val sample_name

    //output:
    //    path "${sample_name}.fastq.gz"

  //  script:
        """
        cat ${in_fastq} > ${sample_name}.fastq.gz
        """
//}





process merge_fastq {
    input:
        val sample_name
        path in_fastq

    output:
        path "${sample_name}.fastq.gz"

    script:
        """
        cat ${in_fastq} | gzip > ${sample_name}.fastq.gz
        """
}


nextflow.enable.dsl=2

// ===== Importation des modules =====
include { merge_fastq }            from './modules/merge_fastq.nf'
include { trim_reads }             from './modules/trim_reads.nf'
include { parse_fastq_qc }         from './modules/parse_fastq_qc.nf'
include { mapping_bam }            from './modules/mapping_bam.nf'
include { parse_bam_qc }           from './modules/parse_bam_qc.nf'
include { bam_indexing }           from './modules/bam_indexing.nf'
include { bam_coverage }           from './modules/bam_coverage.nf'
include { low_coverage_filtering } from './modules/low_coverage_filtering.nf'
include { variant_calling }        from './modules/variant_calling.nf'
include { parse_variant_qc }      from './modules/parse_variant_qc.nf'
include { consensus_generation }   from './modules/consensus_generation.nf'

// ===== Paramètres =====
params.input = null
params.sample = null
params.ref_genome = "/home/etudiant/fatemeh/hbv_pipeline/Ref/sequence.fasta"
params.adapter = "/home/etudiant/fatemeh/hbv_pipeline/primer/HBV_primer.fasta"
params.min_len = 150
params.max_len = 1200
params.min_qual = 10
params.cpu = 10

// ===== Processus de décompression =====
process decompress_archive {
    input:
    path archive_file

    output:
    path "data_extracted"

    script:
    """
    mkdir -p data_extracted
    if [[ "${archive_file}" == *.tar.gz || "${archive_file}" == *.tgz ]]; then
        tar -xzf ${archive_file} -C data_extracted || true
    elif [[ "${archive_file}" == *.tar ]]; then
        tar -xf ${archive_file} -C data_extracted || true
    elif [[ "${archive_file}" == *.zip ]]; then
        unzip -q ${archive_file} -d data_extracted || true
    elif [[ "${archive_file}" == *.gz ]]; then
        gunzip -c ${archive_file} > data_extracted/$(basename ${archive_file} .gz) || true
    fi
    """
}

workflow {

    if (params.input == null) {
        error "❌ Veuillez spécifier un chemin d'entrée avec --input"
    }

    def input_path = file(params.input)
    def fastq_dir
    Channel fastq_ch

    if (input_path.name.endsWith('.zip') || input_path.name.endsWith('.tar.gz') || input_path.name.endsWith('.tar') || input_path.name.endsWith('.gz')) {
        println "🔸 Archive détectée, tentative de décompression..."
        decompress_ch = decompress_archive(input_path)
        fastq_dir = "data_extracted"
    } else {
        fastq_dir = params.input
    }

    def barcode_dirs = file(fastq_dir).listFiles().findAll { it.isDirectory() && it.name.startsWith('barcode') }

    if (file(fastq_dir).isFile()) {
        println "🔹 Mode fichier unique détecté."
        fastq_ch = Channel.of([fastq_dir, fastq_dir])
    }
    else if (barcode_dirs.size() > 0) {
        println "🔹 Mode multiplexé détecté."
        fastq_ch = Channel.fromFilePairs("${fastq_dir}/barcode*/**/*.{fastq,fastq.gz}", flat: true)
    }
    else {
        println "🔹 Mode dossier simple détecté."
        fastq_ch = Channel.fromFilePairs("${fastq_dir}/**/*.{fastq,fastq.gz}", flat: true)
    }

    fastq_ch.view { it -> println "📄 Fichier FASTQ trouvé : ${it}" }

    merged_fastq_ch = merge_fastq(fastq_ch)

    trimmed_fastq_ch = trim_reads(
        merged_fastq_ch,
        params.adapter,
        params.min_len,
        params.max_len,
        params.min_qual,
        params.cpu
    )

    fastq_qc_ch = parse_fastq_qc(merged_fastq_ch)

    mapped_bam_ch = mapping_bam(trimmed_fastq_ch, params.ref_genome)

    bam_qc_ch = parse_bam_qc(mapped_bam_ch)

    bam_index_outputs = bam_indexing(mapped_bam_ch)
    indexed_bam_ch = bam_index_outputs[0]
    indexed_bai_ch = bam_index_outputs[1]

    coverage_bed_ch = bam_coverage(mapped_bam_ch, params.ref_genome)

    filtered_bam_ch = low_coverage_filtering(coverage_bed_ch)

    variant_vcf_ch  = variant_calling(indexed_bam_ch, params.ref_genome)

    variant_qc_ch   = parse_variant_qc(variant_vcf_ch)

    consensus_fa_ch = consensus_generation(indexed_bam_ch, params.ref_genome)

    println "✅ Pipeline terminé pour les fichiers FASTQ."
}




//process merge_fastq {

  //  input:
   // tuple val(sample_id), path(reads)

  //  output:
  //  tuple val(sample_id), path("${sample_id}.fastq.gz")

   // script:
    """
   // cat ${reads.join(' ')} | gzip > ${sample_id}.fastq.gz
    """
//}




nextflow.enable.dsl=2

// ===== Modules imports =====
include { decompress_archive } from './modules/decompress_archive.nf'
include { merge_fastq }        from './modules/merge_fastq.nf'
include { trim_reads }         from './modules/trim_reads.nf'
include { parse_fastq_qc }     from './modules/parse_fastq_qc.nf'

// ===== Paramètres =====
params.input = null
params.adapter = "/home/etudiant/fatemeh/hbv_pipeline/primer/HBV_primer.fasta"
params.min_len = 150
params.max_len = 1200
params.min_qual = 10
params.cpu = 10

workflow {

    if (params.input == null) {
        error "❌ Vous devez donner un chemin avec --input"
    }

    def fastq_ch

    // ==== Décompression automatique si archive ====
    if (file(params.input).isFile() && (params.input.endsWith(".tar.gz") || params.input.endsWith(".zip") || params.input.endsWith(".gz"))) {
        println "🟢 Archive détectée : décompression automatique"

        def archive_ch = Channel.of(file(params.input))
        def decompressed_ch = decompress_archive(archive_ch)

        fastq_ch = decompressed_ch.flatMap { folder ->
            println "🔹 Dossier multiplex détecté après décompression"
            Channel.fromPath("${folder}/*/*.fastq.gz")
                  .map { file -> tuple(file.parent.name, file) }
                  .groupTuple()
        }
    }

    // ==== Dossier multiplex ====
    else if (file(params.input).isDirectory()) {
        println "🔹 Dossier multiplex détecté"
        fastq_ch = Channel.fromPath("${params.input}/*/*.fastq.gz")
                          .map { file -> tuple(file.parent.name, file) }
                          .groupTuple()
    }
    else {
        error "❌ Le chemin donné n'est pas valide"
    }

    // ===== Pipeline =====
    def merged_fastq_ch = merge_fastq(fastq_ch)

    def trimmed_fastq_ch = trim_reads(
        merged_fastq_ch,
        file(params.adapter),
        params.min_len,
        params.max_len,
        params.min_qual,
        params.cpu
    )

    parse_fastq_qc(trimmed_fastq_ch)
}


process parse_fastq_qc {

    input:
    tuple val(sample_id), path(in_fastq)

    output:
    path "${sample_id}_qc.txt"

    script:
    """
    nb_lines=\$(zcat ${in_fastq} | wc -l)
    file_size=\$(du -h ${in_fastq} | cut -f1)

    {
        echo "Sample ID       : ${sample_id}"
        echo "Nombre de lignes: \$nb_lines"
        echo "Taille fichier  : \$file_size"
    } > ${sample_id}_qc.txt
    """
}



process trim_reads {

    input:
    tuple val(sample_id), path(in_fastq)
    path in_adapter
    val min_len
    val max_len
    val min_qual
    val cpu

    output:
    tuple val(sample_id), path("${sample_id}_trim_reads.fastq.gz")

    script:
    """
    cutadapt -j ${cpu} \\
        -a file:${in_adapter} \\
        --discard-untrimmed \\
        -m ${min_len} \\
        -M ${max_len} \\
        -q ${min_qual} \\
        -o ${sample_id}_trim_reads.fastq.gz \\
        ${in_fastq}
    """
}



process merge_fastq {

    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("${sample_id}.fastq")

    script:
    """
    cat ${reads.join(' ')} > ${sample_id}.fastq
    """
}

/////////////////////////////////////////////////////////******************************************************

nextflow.enable.dsl=2

// ===== Modules imports =====
include { merge_fastq }        from './modules/merge_fastq.nf'
include { trim_reads }         from './modules/trim_reads.nf'
include { parse_fastq_qc }     from './modules/parse_fastq_qc.nf'
include { decompress_archive } from './modules/decompress_archive.nf'

// ===== Paramètres =====
params.input = null
params.sample = null
params.adapter = "/home/etudiant/fatemeh/hbv_pipeline/primer/HBV_primer.fasta"
params.min_len = 150
params.max_len = 1200
params.min_qual = 10
params.cpu = 10

workflow {

    if (params.input == null) {
        error "❌ Vous devez donner un chemin avec --input"
    }

    def fastq_ch

    // ==== Si l'entrée est un fichier compressé ====
    if (file(params.input).isFile() && (params.input.endsWith(".tar.gz") || params.input.endsWith(".zip") || params.input.endsWith(".gz"))) {
        println "🟢 Archive détectée : décompression automatique"

        archive_ch = Channel.of(file(params.input))
        decompressed_ch = decompress_archive(archive_ch)

        decompressed_ch.subscribe { folder ->
            def files = file(folder).listFiles()
            if (files.any { it.isDirectory() }) {
                println "🔹 Dossier multiplex détecté après décompression"
                fastq_ch = Channel.fromFilePairs("${folder}/*/*.fastq.gz", flat: true)
            } else {
                println "🔹 Dossier plat détecté après décompression"
                fastq_ch = Channel.fromFilePairs("${folder}/*.fastq.gz", flat: true)
            }
        }
    }

    // ==== Si l'entrée est un dossier ====
    else if (file(params.input).isDirectory()) {
        def files = file(params.input).listFiles()
        if (files.any { it.isDirectory() }) {
            println "🔹 Dossier multiplex détecté"
            fastq_ch = Channel.fromFilePairs("${params.input}/*/*.fastq.gz", flat: true)
        } else {
            println "🔹 Dossier plat détecté"
            fastq_ch = Channel.fromFilePairs("${params.input}/*.fastq.gz", flat: true)
        }
    }

    // ==== Si l'entrée est un fichier FASTQ ====
    else if (file(params.input).isFile()) {
        println "🔹 Fichier unique détecté"
        def sample_name = params.sample ?: file(params.input).baseName
        fastq_ch = Channel.of([sample_name, file(params.input)])
    }

    else {
        error "❌ Le chemin donné n'est pas valide"
    }

    // ===== Pipeline =====
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
}










nextflow.enable.dsl=2

// ===== Modules imports =====
include { merge_fastq }        from './modules/merge_fastq.nf'
include { trim_reads }         from './modules/trim_reads.nf'
include { parse_fastq_qc }     from './modules/parse_fastq_qc.nf'
include { decompress_archive } from './modules/decompress_archive.nf'

// ===== Paramètres =====
params.input = null
params.sample = null
params.adapter = "/home/etudiant/fatemeh/hbv_pipeline/primer/HBV_primer.fasta"
params.min_len = 150
params.max_len = 1200
params.min_qual = 10
params.cpu = 10

workflow {

    if (params.input == null) {
        error "❌ Vous devez donner un chemin avec --input"
    }

    def fastq_ch

    // ==== Si l'entrée est un fichier compressé ====
    if (file(params.input).isFile() && (params.input.endsWith(".tar.gz") || params.input.endsWith(".zip") || params.input.endsWith(".gz"))) {
        println "🟢 Archive détectée : décompression automatique"

        archive_ch = Channel.of(file(params.input))
        decompressed_ch = decompress_archive(archive_ch)

        decompressed_ch.subscribe { folder ->
            def files = file(folder).listFiles()
            if (files.any { it.isDirectory() }) {
                println "🔹 Dossier multiplex détecté après décompression"
                fastq_ch = Channel.fromFilePairs("${folder}/*/*.fastq.gz", flat: true)
            } else {
                println "🔹 Dossier plat détecté après décompression"
                fastq_ch = Channel.fromFilePairs("${folder}/*.fastq.gz", flat: true)
            }
        }
    }

    // ==== Si l'entrée est un dossier ====
    else if (file(params.input).isDirectory()) {
        def files = file(params.input).listFiles()
        if (files.any { it.isDirectory() }) {
            println "🔹 Dossier multiplex détecté"
            fastq_ch = Channel.fromFilePairs("${params.input}/*/*.fastq.gz", flat: true)
        } else {
            println "🔹 Dossier plat détecté"
            fastq_ch = Channel.fromFilePairs("${params.input}/*.fastq.gz", flat: true)
        }
    }

    // ==== Si l'entrée est un fichier FASTQ ====
    else if (file(params.input).isFile()) {
        println "🔹 Fichier unique détecté"
        def sample_name = params.sample ?: file(params.input).baseName
        fastq_ch = Channel.of([sample_name, file(params.input)])
    }

    else {
        error "❌ Le chemin donné n'est pas valide"
    }

    // ===== Pipeline =====
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
}


   merged_fastq_ch = merge_fastq(input_ch)
    trimmed_fastq_ch = trim_reads(merged_fastq_ch, file(params.adapter), params.min_len, params.max_len, params.min_qual, params.cpu)
    parse_fastq_qc(trimmed_fastq_ch)
    mapping_bam(trimmed_fastq_ch, file(params.ref_genome), params.cpu)





    nextflow.enable.dsl=2

// ===== Modules imports =====
include { decompress_archive } from './modules/decompress_archive.nf'
include { merge_fastq }        from './modules/merge_fastq.nf'
include { trim_reads }         from './modules/trim_reads.nf'
include { parse_fastq_qc }     from './modules/parse_fastq_qc.nf'
include { mapping_bam }        from './modules/mapping_bam.nf'

workflow {

    if (params.input == null) {
        error "❌ Vous devez donner un chemin avec --input"
    }

    def input_ch

    // ==== Détection automatique ====
    if (file(params.input).isFile()) {
        println "🔹 Fichier unique détecté"
        def sample_name = params.sample ?: file(params.input).baseName
        input_ch = Channel.of([sample_name, file(params.input)])
    }

    else if (file(params.input).isDirectory()) {
        def files = file(params.input).listFiles()

        if (files.any { it.isDirectory() }) {
            println "🔹 Dossier multiplex détecté"
            input_ch = Channel
                .fromPath("${params.input}/*/*.{fastq.gz,bam}")
                .map { tuple(it.parent.name, it) }
                .groupTuple()
        } else {
            println "🔹 Dossier plat détecté"
            input_ch = Channel.fromFilePairs("${params.input}/*.{fastq.gz,bam}", flat: true)
        }
    }

    else if (file(params.input).isFile() && (params.input.endsWith(".tar.gz") || params.input.endsWith(".zip") || params.input.endsWith(".gz"))) {
        println "🟢 Archive détectée : décompression automatique"

        def archive_ch = Channel.of(file(params.input))
        def decompressed_ch = decompress_archive(archive_ch)

        decompressed_ch.subscribe { folder ->
            def files = file(folder).listFiles()
            if (files.any { it.isDirectory() }) {
                println "🔹 Dossier multiplex détecté après décompression"
                input_ch = Channel
                    .fromPath("${folder}/*/*.{fastq.gz,bam}")
                    .map { tuple(it.parent.name, it) }
                    .groupTuple()
            } else {
                println "🔹 Dossier plat détecté après décompression"
                input_ch = Channel.fromFilePairs("${folder}/*.{fastq.gz,bam}", flat: true)
            }
        }
    }

    else {
        error "❌ Le chemin donné n'est pas valide"
    }

    // ===== Pipeline =====

    merged_fastq_ch = merge_fastq(input_ch)
    trimmed_fastq_ch = trim_reads(merged_fastq_ch, file(params.adapter), params.min_len, params.max_len, params.min_qual, params.cpu)
    parse_fastq_qc(trimmed_fastq_ch)
    mapping_bam(trimmed_fastq_ch, file(params.ref_genome), params.cpu)
}


//nextflow.enable.dsl=2

// ===== Modules imports =====
include { merge_fastq }        from './modules/merge_fastq.nf'
include { trim_reads }         from './modules/trim_reads.nf'
include { parse_fastq_qc }     from './modules/parse_fastq_qc.nf'
include { decompress_archive } from './modules/decompress_archive.nf'

// ===== Paramètres =====
params.input        = null
params.sample       = null
params.adapter      = "./primer/HBV_primer.fasta"
params.ref_genome   = "./Ref/sequence.fasta"
params.result_dir   = "./results"
params.min_len      = 150
params.max_len      = 1200
params.min_qual     = 10
params.cpu          = 4

// ===== Fonctions =====
/**
 * Fonction qui détecte le type d'entrée
 * et retourne un Channel dynamique
 */
def detect_input(input_path) {

    def input_file = file(input_path)

    if (!input_file.exists()) {
        error "❌ Chemin invalide : ${input_path}"
    }

    // ==== Cas archive ====
    if (input_file.isFile() && (input_file.name.endsWith(".tar.gz") || input_file.name.endsWith(".zip") || input_file.name.endsWith(".gz"))) {
        println "🟢 Archive détectée : décompression automatique"

        def archive_ch = Channel.of(input_file)
        def decompressed_ch = decompress_archive(archive_ch)

        return decompressed_ch.map { folder ->
            def files = file(folder).listFiles()
            if (files.any { it.isDirectory() }) {
                println "🔹 Dossier multiplex détecté après décompression"
                return Channel.fromFilePairs("${folder}/*/*.fastq.gz", flat: true)
            } else {
                println "🔹 Dossier plat détecté après décompression"
                return Channel.fromFilePairs("${folder}/*.fastq.gz", flat: true)
            }
        }.flatten()
    }

    // ==== Cas dossier ====
    if (input_file.isDirectory()) {
        def files = input_file.listFiles()
        if (files.any { it.isDirectory() }) {
            println "🔹 Dossier multiplex détecté"
            return Channel.fromFilePairs("${input_path}/*/*.fastq.gz", flat: true)
        } else {
            println "🔹 Dossier plat détecté"
            return Channel.fromFilePairs("${input_path}/*.fastq.gz", flat: true)
        }
    }

    // ==== Cas fichier FASTQ ====
    if (input_file.isFile()) {
        println "🔹 Fichier unique détecté"
        def sample_name = params.sample ?: input_file.baseName
        return Channel.of([sample_name, input_file])
    }

    error "❌ Format non reconnu"
}

// ===== Pipeline =====
workflow {

    if (params.input == null) {
        error "❌ Vous devez fournir --input"
    }

    fastq_ch = detect_input(params.input)

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
}






//////////////////******

nextflow.enable.dsl=2

// ===== Modules imports =====
include { merge_fastq }        from './modules/merge_fastq.nf'
include { trim_reads }         from './modules/trim_reads.nf'
include { parse_fastq_qc }     from './modules/parse_fastq_qc.nf'
include { decompress_archive } from './modules/decompress_archive.nf'

// ===== Paramètres =====
params.input        = null
params.sample       = null
params.adapter      = "./primer/HBV_primer.fasta"
params.ref_genome   = "./Ref/sequence.fasta"
params.result_dir   = "./results"
params.min_len      = 150
params.max_len      = 1200
params.min_qual     = 10
params.cpu          = 4

// ===== Pipeline =====
workflow {

    if (params.input == null) {
        error "❌ Vous devez fournir --input"
    }

    def input_file = file(params.input)

    // ==== Dossier multiplex ====
    if (input_file.isDirectory() && input_file.list().any { file("${params.input}/${it}").isDirectory() }) {
        println "🔹 Dossier multiplex détecté"

        Channel
            .fromPath("${params.input}/*/*.fastq.gz")
            .collect()
            .map { files ->
                files.groupBy { it.parent.name }
                    .collect { key, list -> tuple(key, list.sort()) }
            }
            .flatten()
            .set { fastq_ch }
    }

    // ==== Dossier plat ====
    else if (input_file.isDirectory()) {
        println "🔹 Dossier plat détecté"

        Channel
            .fromPath("${params.input}/*.fastq.gz")
            .collect()
            .map { files -> tuple("sample", files.sort()) }
            .set { fastq_ch }
    }

    // ==== Fichier unique ====
    else if (input_file.isFile()) {
        println "🔹 Fichier unique détecté"

        def sample_name = params.sample ?: input_file.baseName
        Channel
            .of(tuple(sample_name, [input_file]))
            .set { fastq_ch }
    }

    else {
        error "❌ Chemin invalide : ${params.input}"
    }

    // ===== Pipeline execution =====
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
}


///////////////


nextflow.enable.dsl=2

// ===== Modules imports =====
include { decompress_archive } from './modules/decompress_archive.nf'
include { merge_fastq }        from './modules/merge_fastq.nf'
include { trim_reads }         from './modules/trim_reads.nf'
include { parse_fastq_qc }     from './modules/parse_fastq_qc.nf'


// ===== Paramètres =====
params.input        = null
params.sample       = null
params.adapter      = "./primer/HBV_primer.fasta"
params.ref_genome   = "./Ref/sequence.fasta"
params.result_dir   = "./results"
params.min_len      = 150
params.max_len      = 1200
params.min_qual     = 10
params.cpu          = 4

// ===== Pipeline =====
workflow {

    if (params.input == null) {
        error "❌ Vous devez fournir --input"
    }

    def input_file = file(params.input)

    // ==== Dossier multiplex ====
    if (input_file.isDirectory() && input_file.list().any { file("${params.input}/${it}").isDirectory() }) {
        println "🔹 Dossier multiplex détecté"

        Channel
            .fromPath("${params.input}/*/*.fastq.gz")
            .collect()
            .filter { it.exists() && it.size() > 0 }  // Ignore empty or missing files
            .map { files ->
                files.groupBy { it.parent.name }
                    .collect { key, list -> tuple(key, list.sort()) }
            }
            .filter { it[1].size() > 0 }  // Ensure that barcode has valid files
            .flatten()
            .set { fastq_ch }
    }

    // ==== Dossier plat ====
    else if (input_file.isDirectory()) {
        println "🔹 Dossier plat détecté"

        Channel
            .fromPath("${params.input}/*.fastq.gz")
            .collect()
            .filter { it.exists() && it.size() > 0 }  // Ignore empty or missing files
            .map { files -> tuple("sample", files.sort()) }
            .set { fastq_ch }
    }

    // ==== Fichier unique ====
    else if (input_file.isFile()) {
        println "🔹 Fichier unique détecté"

        def sample_name = params.sample ?: input_file.baseName
        Channel
            .of(tuple(sample_name, [input_file]))
            .set { fastq_ch }
    }

    else {
        error "❌ Chemin invalide : ${params.input}"
    }

    // ===== Pipeline execution =====
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
}



nextflow.enable.dsl=2

// ========== MODULES ==========
include { decompress_archive } from './modules/decompress_archive.nf'
include { merge_fastq }        from './modules/merge_fastq.nf'
include { trim_reads }         from './modules/trim_reads.nf'
include { parse_fastq_qc }     from './modules/parse_fastq_qc.nf'

// ========== PARAMÈTRES ==========
params.input        = null
params.sample       = null
params.adapter      = "./primer/HBV_primer.fasta"
params.ref_genome   = "./Ref/sequence.fasta"
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
}


////////////////////*

nextflow.enable.dsl=2

// ========== MODULES ==========
include { decompress_archive } from './modules/decompress_archive.nf'
include { merge_fastq }        from './modules/merge_fastq.nf'
include { trim_reads }         from './modules/trim_reads.nf'
include { parse_fastq_qc }     from './modules/parse_fastq_qc.nf'

// ========== PARAMÈTRES ==========
params.input        = null
params.sample       = null
params.adapter      = "./primer/HBV_primer.fasta"
params.result_dir   = "./results"
params.min_len      = 150
params.max_len      = 1200
params.min_qual     = 10
params.cpu          = 4

// ========== WORKFLOW PRINCIPAL ==========
workflow {

    // Vérification que --input est fourni
    if (params.input == null) {
        error "❌ Vous devez fournir --input"
    }

    def input_file = file(params.input)

    // ===========================
    // 📦 CAS 1 : Archive compressée (tar.gz, zip, gz)
    // ===========================
    if (input_file.name.endsWith(".tar.gz") || input_file.name.endsWith(".zip") || input_file.name.endsWith(".gz")) {
        println "🔹 Archive compressée détectée"

        Channel
            .of(input_file)
            .set { archive_ch }

        decompress_archive(archive_ch)
            .map { file("decompressed") }
            .set { real_input_dir }
    }

    // ===========================
    // 📁 CAS 2 : Dossier détecté
    // ===========================
    else if (input_file.isDirectory()) {
        println "🔹 Dossier détecté"
        Channel
            .of(input_file)
            .set { real_input_dir }
    }

    // ===========================
    // 📄 CAS 3 : Fichier FASTQ unique
    // ===========================
    else if (input_file.name.endsWith(".fastq.gz")) {
        println "🔹 Fichier FASTQ unique détecté"

        def sample_name = params.sample ?: input_file.baseName
        Channel
            .of(tuple(sample_name, [input_file]))
            .set { fastq_ch }

        // Exécution du pipeline directement pour le fichier unique
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

        return
    }

    else {
        error "❌ Chemin invalide : ${params.input}"
    }

    // ===========================
    // 🔍 DÉTECTION DANS LE DOSSIER (plat ou multiplex)
    // ===========================
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

    // ===========================
    // 🚀 PIPELINE BIOINFORMATIQUE
    // ===========================
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
}




//////////////////////////////**/

process merge_fastq {
    input:
    tuple val(sample_id), path(fastq_files)

    output:
    tuple val(sample_id), path("${sample_id}.merged.fastq.gz")

    publishDir "${params.result_dir}/${sample_id}", mode: 'copy'

    script:
    """
    cat ${fastq_files.join(' ')} > ${sample_id}.merged.fastq.gz
    """
}



//***

process trim_reads {
    input:
    tuple val(sample_id), path(fastq_file)
    path adapter_fasta
    val min_len
    val max_len
    val min_qual
    val cpu

    output:
    tuple val(sample_id), path("${sample_id}_trim_reads.fastq.gz")

     publishDir "${params.result_dir}/${sample_id}", mode: 'copy'


    script:
    """
    cutadapt \
        -a file:$adapter_fasta \
        -m $min_len -M $max_len -q $min_qual \
        -j $cpu \
        -o ${sample_id}_trim_reads.fastq.gz \
        $fastq_file
    """
}



/////////

process parse_fastq_qc {
    input:
    tuple val(sample_id), path(trimmed_fastq)

    output:
    path("${sample_id}_qc.txt")

    publishDir "${params.result_dir}/${sample_id}", mode: 'copy'

    script:
    """
    echo "QC report for $sample_id" > ${sample_id}_qc.txt
    echo "Number of reads: \$(zcat $trimmed_fastq | wc -l | awk '{print \$1/4}')" >> ${sample_id}_qc.txt
    echo "Total lines: \$(zcat $trimmed_fastq | wc -l)" >> ${sample_id}_qc.txt
    """
}



/////////////

process mapping_bam {
    input:
    tuple val(sample_id), path(trimmed_fastq)
    val ref_genome
    val cpu

    output:
    path "${sample_id}.sorted.bam"

    publishDir "${params.result_dir}/${sample_id}", mode: 'copy'

    script:
    """
    set -e
    minimap2 -ax map-ont ${ref_genome} ${trimmed_fastq} | \\
    samtools view -Sb - | \\
    samtools sort -o ${sample_id}.sorted.bam
    """
}





///////////////

process bam_indexing {
    input:
        path sorted_bam  // Fichier BAM trié

    output:
        path "${sorted_bam}"  // BAM trié indexé
        path "${sorted_bam}.bai"  // Fichier index BAM

    script:
        """
        set -e
        samtools index ${sorted_bam}
        """
}


////////

process bam_coverage {
    input:
        path sorted_bam   // Fichier BAM trié
        path ref_genome   // Fichier de référence du génome

    output:
        path "${sorted_bam.baseName}.coverage.bed"  // Fichier .bed contenant la couverture

    script:
        """
        set -e  # Arrêter l'exécution en cas d'erreur

        # Calcul de la couverture avec bedtools
        bedtools genomecov -bg -ibam ${sorted_bam} > ${sorted_bam.baseName}.coverage.bed
        """
}


////////////

process low_coverage_filtering {
    input:
        path coverage_bed  // Fichier de couverture généré par `bam_coverage`

    output:
        path "${coverage_bed.baseName}_low_coverage.bed"  // Fichier BED des régions à faible couverture

    script:
        """
        set -e  # Arrêter l'exécution en cas d'erreur

        # Filtrer les régions avec une couverture < 20
        awk '\$4 < 20 {print \$1, \$2, \$3}' ${coverage_bed} > ${coverage_bed.baseName}_low_coverage.bed
        """
}


/////////////

process variant_calling {
    input:
        path sorted_bam   // Fichier BAM trié
        path sorted_bai   // Fichier index BAM
        path ref_genome   // Génome de référence

    output:
        path "${sorted_bam.baseName}.vcf.gz"      // Fichier VCF compressé
        path "${sorted_bam.baseName}.vcf.gz.tbi"  // Index du fichier VCF compressé

    script:
        """
        set -e  # Arrêter l'exécution en cas d'erreur

        # Génération du fichier VCF brut
        bcftools mpileup -d 8000 -f ${ref_genome} ${sorted_bam} | \\
        bcftools call -mv | \\
        bcftools filter -e 'QUAL<20' -Ov -o ${sorted_bam.baseName}.vcf

        # Compression et indexation
        bgzip -c ${sorted_bam.baseName}.vcf > ${sorted_bam.baseName}.vcf.gz
        tabix -p vcf ${sorted_bam.baseName}.vcf.gz
        """
}




process consensus_generation {
    input:
        path vcf_gz        // Fichier VCF compressé contenant les variants
        path vcf_tbi       // Index du fichier VCF compressé
        path ref_genome    // Génome de référence (FASTA)
        path low_coverage  // Fichier BED des régions à faible couverture

    output:
        path "${vcf_gz.baseName}_consensus.fasta"  // Fichier FASTA final

    script:
        """
        set -e  # Arrêter l'exécution en cas d'erreur

        # Vérification des fichiers
        ls -lh ${vcf_gz} ${vcf_tbi} ${ref_genome} ${low_coverage}

        # Génération du consensus
        bcftools consensus -f ${ref_genome} -m ${low_coverage} ${vcf_gz} > ${vcf_gz.baseName}_consensus.fasta
        """
}






// ========== WORKFLOW PRINCIPAL ==========
workflow {

    if (!params.input) {
        error "❌ Vous devez fournir un chemin d’entrée avec --input"
    }

    def input_path = file(params.input)
    Channel fastq_ch

    // === CAS 1 : Archive compressée ===
    if (input_path.name.endsWith('.tar.gz') || input_path.name.endsWith('.zip') || input_path.name.endsWith('.gz')) {
        decompress_archive(Channel.of(input_path))
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
            .set { fastq_ch }
    }

    // === CAS 2 : Dossier plat ===
    else if (input_path.isDirectory() && !input_path.list().any { file("${params.input}/${it}").isDirectory() }) {
        println "🔹 Dossier plat détecté"
        def files = file("${params.input}/*.fastq.gz").sort()
        fastq_ch = Channel.of(tuple("sample", files))
    }

    // === CAS 3 : Dossier multiplex ===
    else if (input_path.isDirectory() && input_path.list().any { file("${params.input}/${it}").isDirectory() }) {
        println "🔹 Dossier multiplex détecté"
        def grouped = file("${params.input}/*/*.fastq.gz").groupBy { it.parent.name }
        def tuples = grouped.collect { name, list -> tuple(name, list.sort()) }
        fastq_ch = Channel.from(tuples)
    }

    // === CAS 4 : Fichier unique .fastq.gz ===
    else if (input_path.name.endsWith('.fastq.gz')) {
        println "🔹 Fichier unique FASTQ détecté"
        def sample_name = params.sample ?: input_path.baseName
        fastq_ch = Channel.of(tuple(sample_name, [input_path]))
    }

    // === Autre cas : erreur
    else {
        error "❌ Chemin d’entrée invalide ou non supporté : ${params.input}"
    }

    // === PIPELINE ===

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

   // lowcov_ch = low_coverage_filtering(coverage_ch)

    //variant_ch = variant_calling(
        mapped_bam_ch.map { id, bam -> bam },
        indexed_bam_ch.map { id, bai -> bai },
        file(params.ref_genome)
    //)

    //parse_variant_qc(variant_ch)

    //consensus_generation(variant_ch, file(params.ref_genome), lowcov_ch)
}



/////////************************///////// 07/04/2025

process low_coverage_filtering {

    input:
    tuple val(sample_id), path(coverage_file)

    output:
    path("${sample_id}_low_coverage.bed")

    publishDir "${params.result_dir ?: './results'}/${sample_id}/low_coverage", mode: 'copy'

    script:
    """
    set -e
    awk '\$4 < 20 {print \$1, \$2, \$3}' ${coverage_file} > ${sample_id}_low_coverage.bed
    """
}

process variant_calling {
    input:
        path sorted_bam
        path sorted_bai
        path ref_genome

    output:
        path "${sorted_bam.baseName}.vcf.gz"
        path "${sorted_bam.baseName}.vcf.gz.tbi"

    publishDir "${params.result_dir ?: './results'}/${sorted_bam.simpleName}", mode: 'copy'

    script:
    """
    bcftools mpileup -d 8000 -f ${ref_genome} ${sorted_bam} | \\
    bcftools call -mv | \\
    bcftools filter -e 'QUAL<20' -Ov -o ${sorted_bam.baseName}.vcf

    bgzip -c ${sorted_bam.baseName}.vcf > ${sorted_bam.baseName}.vcf.gz
    tabix -p vcf ${sorted_bam.baseName}.vcf.gz
    """
}




process variant_calling {

    input:
    tuple val(sample_id), path(bam_file), path(bai_file)
    path ref_genome

    output:
    path("${sample_id}.sorted.vcf.gz")
    path("${sample_id}.sorted.vcf.gz.tbi")

    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    set -e

    # Appel de variants avec bcftools
    bcftools mpileup -Ou -f ${ref_genome} ${bam_file} | \\
    bcftools call -mv -Oz -o ${sample_id}.sorted.vcf.gz

    # Indexation du VCF compressé
    bcftools index ${sample_id}.sorted.vcf.gz
    """
}





process parse_variant_qc {

    input:
    tuple val(sample_id), path(vcf_file)

    output:
    path("${sample_id}_variant_qc.txt")

    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    set -e

    bcftools query -f '%CHROM\\t%POS\\t[%DP]\\t[%AD]\\n' ${vcf_file} | awk '
    BEGIN {
        OFS = "\\t"
        print "CHROM", "POS", "DP", "AD", "Relative_AD"
    }
    {
        chrom = \$1
        pos = \$2
        dp = \$3 + 0
        ad = \$4 + 0
        if (dp >= 10 && ad / dp >= 0.25)
            print chrom, pos, dp, ad, ad/dp
    }
    ' > ${sample_id}_variant_qc.txt
    """
}





process consensus_generation {
    input:
        path vcf_gz        // Fichier VCF compressé
        path vcf_tbi       // Index .tbi du fichier VCF
        path ref_genome    // Fichier FASTA du génome de référence
        path low_coverage  // Fichier BED avec les régions à faible couverture

    output:
        path "${vcf_gz.baseName}_consensus.fasta"  // Résultat final

    publishDir "${params.result_dir ?: './results'}", mode: 'copy'

    script:
    """
    # Commande bcftools pour générer la séquence consensus
    bcftools consensus \\
        -f ${ref_genome} \\
        -m ${low_coverage} \\
        ${vcf_gz} > ${vcf_gz.baseName}_consensus.fasta
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
