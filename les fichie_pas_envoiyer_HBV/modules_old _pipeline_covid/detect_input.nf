nextflow.enable.dsl=2

def detect_input() {

    def input_path = file(params.input)

    if (!input_path.exists()) {
        error "❌ Le chemin donné n'existe pas : ${params.input}"
    }

    if (input_path.isFile()) {
        log.info "📄 Détection : Fichier unique"
        return Channel.of([params.sample ?: error "❗️Spécifiez --sample avec --input", input_path])
    }

    if (input_path.isDirectory()) {
        def subdirs = input_path.listFiles().findAll { it.isDirectory() }

        if (subdirs) {
            log.info "📂 Détection : Dossier multiplex"
            return Channel
                .fromPath("${params.input}/*/*.{fastq.gz,bam}")
                .map { tuple(it.parent.name, it) }
                .groupTuple()
        } else {
            log.info "📂 Détection : Dossier simple (flat)"
            return Channel
                .fromFilePairs("${params.input}/*.{fastq.gz,bam}", flat: true)
        }
    }

    error "❌ Le chemin donné est invalide"
}





