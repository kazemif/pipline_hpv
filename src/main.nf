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
include { parse_variant_qc }       from './modules/parse_variant_qc.nf'
include { consensus_generation }   from './modules/consensus_generation.nf'
//include { GENERATE_REPORT }        from './modules/local/generate_report.nf'

// ========== PARAMÈTRES ==========
params.input        = null
params.sample       = null
//params.adapter      = "/home/etudiant/fatemeh/hbv_pipeline/primer/HBV_primer.fasta"
//params.ref_genome   = "/home/etudiant/fatemeh/hbv_pipeline/Ref/sequence.fasta"  // Reference genomique
params.result_dir   = "./results"
params.min_len      = 150
params.max_len      = 1200
params.min_qual     = 10
params.cpu          = 4

params.adapter    = "./primer/HBV_primer.fasta"
params.ref_genome = "./Ref/sequence.fasta"

// ========== DÉTECTION AUTOMATIQUE DU TYPE D’ENTRÉE ==========
def detect_input_type(path) {
    def input_path = file(path)

    if (input_path.name.endsWith('.tar.gz') || input_path.name.endsWith('.zip') || input_path.name.endsWith('.gz')) {
        return decompress_archive(Channel.of(input_path))
            .map { file("decompressed") }
            .map { folder ->
                def subdirs = folder.list().findAll { file("${folder}/${it}").isDirectory() }
                if (subdirs) {
                    println " Dossier multiplex détecté après décompression"
                    def grouped = file("${folder}/*/*.fastq.gz").groupBy { it.parent.name }
                    grouped.collect { name, list -> tuple(name, list.sort()) }
                } else {
                    println " Dossier plat détecté après décompression"
                    [ tuple("sample", file("${folder}/*.fastq.gz").sort()) ]
                }
            }
            .flatten()
    }

    else if (input_path.isDirectory() && !input_path.list().any { file("${input_path}/${it}").isDirectory() }) {
        println " Dossier plat détecté"
        def files = file("${input_path}/*.fastq.gz").sort()
        return Channel.of(tuple("sample", files))
    }

    else if (input_path.isDirectory() && input_path.list().any { file("${input_path}/${it}").isDirectory() }) {
        println " Dossier multiplex détecté"
        def grouped = file("${input_path}/*/*.fastq.gz").groupBy { it.parent.name }
        def tuples = grouped.collect { name, list -> tuple(name, list.sort()) }
        return Channel.from(tuples)
    }

    else if (input_path.name.endsWith('.fastq.gz')) {
        println " Fichier unique FASTQ détecté"
        def sample_name = params.sample ?: input_path.baseName
        return Channel.of(tuple(sample_name, [input_path]))
    }

    else {
        error " Chemin d entrée invalide ou non supporté : ${params.input}"
    }
}

// ========== WORKFLOW PRINCIPAL ==========
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

    coverage_ch = bam_coverage(
        mapped_bam_ch.map { id, bam, sam -> tuple(id, bam) },
        file(params.ref_genome)
    )

    lowcov_ch = coverage_ch.map { sample_id, bedfile -> 
        tuple(sample_id, bedfile)
    }

    lowcov_filtered = low_coverage_filtering(lowcov_ch)

    variant_input_ch = mapped_bam_ch
        .map { sample_id, bam, sam -> tuple(sample_id, bam) }
        .join(indexed_bam_ch.map { sample_id, bai -> tuple(sample_id, bai) })
        .map { sample_id, bam, bai -> tuple(sample_id, bam, bai) }

    variant_ch = variant_calling(variant_input_ch, file(params.ref_genome))

    variant_qc_input_ch = variant_ch
        .join(mapped_bam_ch.map { id, bam, sam -> tuple(id, bam) })
        .map { id, vcf, vcf_idx, bam -> tuple(id, vcf, vcf_idx, bam) }

    variant_qc_ch = parse_variant_qc(variant_qc_input_ch, file(params.ref_genome))

    consensus_input_ch = variant_ch
        .join(lowcov_ch)
        .map { sample_id, vcf, tbi, bed -> 
            tuple(sample_id, vcf, tbi, file(params.ref_genome), bed)
        }

    consensus_fa_ch = consensus_generation(consensus_input_ch)









    // === Étape finale : génération du rapport HTML ===
    //
    // On crée trois channels pour envoyer le Rmd, le fichier R (fonctions) et le dossier `results/` dans le process :
    rmd_file_ch    = Channel.of(file("rapport_final.Rmd"))
    fonctions_ch   = Channel.of(file("fonctions_globales.R"))
    base_dir_ch    = Channel.of(file(params.result_dir))

    // Le process GENERATE_REPORT va :
    //  1) recevoir `rapport_final.Rmd`, `fonctions_globales.R`, et le dossier `results/` (qui contient tous vos QC/plots)
    //  2) exécuter `rmarkdown::render()` en utilisant `base_dir = "./results"`, donc l’Rmd peut lire les données
    //  3) produire `rapport_final.html` dans le workdir, puis `publishDir` copie ce HTML dans `./results/reports/`
    //report_html_ch = GENERATE_REPORT(rmd_file_ch, fonctions_ch, base_dir_ch)
}

// ========== DÉFINITION DU PROCESS GENERATE_REPORT ==========
//process GENERATE_REPORT {
  //  tag "report"
    //publishDir "${params.result_dir}/reports", mode: 'copy'

   // input:
   // path rmd_file            // 'rapport_final.Rmd'
  //  path fonctions_globales  // 'fonctions_globales.R'
  //  path base_dir            // dossier './results/' sur la machine hôte

  //  output:
  //  path "rapport_final.html"

  //  script:
  //  """
  //  # On se trouve automatiquement dans un sous-dossier temporaire (work/…).
  //  # Nextflow a copié ici :
  //  #   - le dossier 'results/' (avec tout son contenu QC/plots)
  //  #   - le fichier 'rapport_final.Rmd'
  //  #   - le fichier 'fonctions_globales.R'
  //  #
  //  # On crée un dossier temporaire pour stocker le HTML final :
  //  mkdir -p work_reports

  //  # On lance directement Rscript pour rendre le Rmd en fixant les variables d environnement :
 //   Rscript -e " \
  //      Sys.setenv(BASE_DIR_RMD='results'); \
  //      Sys.setenv(OUTPUT_DIR_RMD='work_reports'); \
  //      rmarkdown::render(basename('${rmd_file}'), output_dir='work_reports') \
  //  "

 //   # On copie le HTML généré vers la racine du workdir pour que Nextflow le publie :
  //  cp work_reports/rapport_final.html ./rapport_final.html
  //  """
//}

