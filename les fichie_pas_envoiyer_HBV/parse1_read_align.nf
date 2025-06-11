process parse_bam_files {

    tag "$sample_id"

    input:
    path bam_file  // Fichier BAM

    output:
    path "fastq_qc_${sample_id}.tsv"
    path "fastq_qc_${sample_id}.csv", optional: true

    publishDir "${params.result_dir ?: './results'}/${sample_id}/qc_fastq", mode: 'copy'

    script:
    """
    echo "🔍 Traitement de : ${sample_id}"

    # Vérifie si le fichier BAM existe
    if [ ! -s ${bam_file} ]; then
        echo "❌ Fichier vide : ${bam_file}"
        echo -e "sample_id\\tstatus\\tnote" > fastq_qc_${sample_id}.tsv
        echo -e "${sample_id}\\tvide\\tFichier BAM vide" >> fastq_qc_${sample_id}.tsv
        exit 0
    fi

    # Si BAM est valide, exécute ton code de métriques
    python3 ${params.fastq_qc_script} \\
        --input ${bam_file} \\
        --output output_${sample_id} \\
        --sample ${sample_id}

    # Vérifie si un fichier CSV a été généré
    CSV_FILE=\$(ls output_${sample_id}/*.csv 2>/dev/null || true)

    if [ -z "\$CSV_FILE" ]; then
        echo "⚠️ Aucun fichier CSV généré"
        echo -e "sample_id\\tstatus\\tnote" > fastq_qc_${sample_id}.tsv
        echo -e "${sample_id}\\tvide\\tAucune donnée analysable" >> fastq_qc_${sample_id}.tsv
    else
        mv \$CSV_FILE fastq_qc_${sample_id}.csv
        echo -e "sample_id\\tstatus\\tnote" > fastq_qc_${sample_id}.tsv
        echo -e "${sample_id}\\tsuccès\\tFichier CSV généré" >> fastq_qc_${sample_id}.tsv
    fi
    """
}

