process parse_fastq_qc {
    tag "$sample_id"

    input:
    tuple val(sample_id), path(trimmed_fastq)

    // On renvoie le dossier entier
    output:
    tuple val(sample_id), path("output_${sample_id}")

    publishDir "${params.result_dir ?: './results'}/${sample_id}/qc_fastq", mode: 'copy'

    script:
    """
    set -e
    echo "🔍 Traitement de : ${sample_id}"
    mkdir -p output_${sample_id}

    if [ ! -s ${trimmed_fastq} ]; then
        echo "❌ Fichier FASTQ vide ou inexistant : ${trimmed_fastq}"
        exit 1
    fi

    gunzip -c ${trimmed_fastq} > ${sample_id}_trimmed.fastq

    python3 ${params.fastq_qc_script} \
        --input ${sample_id}_trimmed.fastq \
        --output output_${sample_id} \
        --sample ${sample_id}

    echo "📁 Fichiers générés :"
    ls -lh output_${sample_id}

    # (Plus d’archive ici)
    rm -f ${sample_id}_trimmed.fastq
    """
}






















