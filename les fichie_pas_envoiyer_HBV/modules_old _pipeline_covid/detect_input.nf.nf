nextflow.enable.dsl=2

workflow detect_input {

    take:
    input_path

    main:
    emit:
    input_ch

    if (!input_path) {
        error "❗️Vous devez donner un chemin avec --input"
    }

    input_ch = Channel.empty()

    Channel.fromPath(input_path)
        .ifEmpty { error "❌ Aucun fichier trouvé dans ${input_path}" }
        .map { file(it) }
        .collect()
        .view { files -> 
            def first = files[0]
            if (first.isFile()) {
                log.info "📄 Détection : Fichier unique"
                input_ch = Channel.of([params.sample ?: error "❗️Spécifiez --sample", first])
            } else if (first.isDirectory()) {
                def has_subdirs = files.find { it.isDirectory() && it.listFiles().find { it.isDirectory() } }
                if (has_subdirs) {
                    log.info "📂 Détection : Dossier multiplex"
                    input_ch = Channel
                        .fromPath("${input_path}/*/*.{fastq.gz,bam}")
                        .map { tuple(it.parent.name, it) }
                        .groupTuple()
                } else {
                    log.info "📂 Détection : Dossier simple (flat)"
                    input_ch = Channel
                        .fromFilePairs("${input_path}/*.{fastq.gz,bam}", flat: true)
                }
            } else {
                error "❌ Format d'entrée non reconnu"
            }
        }
}





