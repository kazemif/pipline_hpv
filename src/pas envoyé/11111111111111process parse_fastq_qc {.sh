
process parse_fastq_qc {

    input:
    tuple val(sample_id), path(trimmed_fastq)

    output:
    path("${sample_id}_qc.txt")

     #Sécurisé avec fallback : si params.result_dir est null, utiliser "./results"
    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    echo 'Fichier : ${trimmed_fastq}' > ${sample_id}_qc.txt
    echo 'Nombre de lignes :' >> ${sample_id}_qc.txt
    zcat ${trimmed_fastq} | wc -l >> ${sample_id}_qc.txt
    echo 'Taille fichier :' >> ${sample_id}_qc.txt
    du -h ${trimmed_fastq} >> ${sample_id}_qc.txt
    """
}




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

    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    cutadapt \\
        -a file:${adapter_fasta} \\
        -m ${min_len} -M ${max_len} \\
        -q ${min_qual} \\
        -j ${cpu} \\
        -o ${sample_id}_trim_reads.fastq.gz \\
        ${fastq_file}
    """
}


////#########################################////////////////////

process parse_fastq_qc {
    tag "$sample_id"

    input:
    tuple val(sample_id), path(trimmed_fastq)

    output:
    tuple val(sample_id), path("fastq_qc_${sample_id}.tar.gz")

    publishDir "${params.result_dir ?: './results'}/${sample_id}/qc_fastq", mode: 'copy'

    script:
    """
    set -e
    echo "🔍 Traitement de : ${sample_id}"
    mkdir -p output_${sample_id}

    # Vérifie que le fichier FASTQ compressé existe
    if [ ! -s ${trimmed_fastq} ]; then
        echo "❌ Fichier FASTQ vide ou inexistant : ${trimmed_fastq}"
        exit 1
    fi

    # Décompression du fichier FASTQ
    gunzip -c ${trimmed_fastq} > ${sample_id}_trimmed.fastq

    # Exécution du script Python
    python3 ${params.fastq_qc_script} \\
        --input ${sample_id}_trimmed.fastq \\
        --output output_${sample_id} \\
        --sample ${sample_id}

    echo "📁 Fichiers générés :"
    ls -lh output_${sample_id}

    # Création d’une archive contenant tous les fichiers de sortie
    tar -czf fastq_qc_${sample_id}.tar.gz -C output_${sample_id} .

    # Nettoyage temporaire
    rm -f ${sample_id}_trimmed.fastq
    """
//}




##////////////////////////////////////

process parse_read_align {

  tag "${sample}"  // Pour suivi dans le log

  input:
    tuple val(sample), path(bam_file)   // Reçoit le nom du sample et le fichier BAM

  output:
    path "${sample}_read_align_stats", emit: parsed_stats  // Dossier avec les résultats

  publishDir "${params.result_dir ?: './results'}/${sample}", mode: 'copy'

  script:
    """
    mkdir ${sample}_read_align_stats

    parse_read_align \\
      -i ${bam_file} \\
      -o ${sample}_read_align_stats \\
      -c ${params.cpu} \\
      -s ${sample}
    """
}









///////////////////////////////*****
:::::::::::::://////////

process variant_calling {

    input:
    tuple val(sample_id), path(bam_file), path(bai_file)
    path ref_genome

    //output:
    //path("${sample_id}.sorted.vcf.gz")
    //path("${sample_id}.sorted.vcf.gz.tbi")
    output:
    tuple val(sample_id), path("${sample_id}.sorted.vcf.gz"), path("${sample_id}.sorted.vcf.gz.tbi")


    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    set -e

    # Appel de variants avec filtre qualité, VCF compressé
    bcftools mpileup -d 8000 -f ${ref_genome} ${bam_file} | \\
    bcftools call -mv | \\
    bcftools filter -e 'QUAL<20' -Oz -o ${sample_id}.sorted.vcf.gz

    # Indexation avec tabix (format VCF)
    tabix -p vcf ${sample_id}.sorted.vcf.gz
    """
}












# //////////

process parse_variant_qc {

    tag "${sample_id}"

    input:
    tuple val(sample_id), path(vcf_file)

    output:
    tuple val(sample_id), path("${sample_id}_filtered.vcf"), path("${sample_id}_pileup.csv")

    publishDir "${params.result_dir}/${sample_id}/variant_qc", mode: 'copy'

    script:
    """
    set -e

    # Définir le PYTHONPATH avec les backticks
    export PYTHONPATH=`dirname \`dirname ${params.variant_qc_script}\``

    # Lancer le script Python
    python3 ${params.variant_qc_script} \\
        --vcf ${vcf_file} \\
        --bam ${params.result_dir}/${sample_id}/${sample_id}.sorted.bam \\
        --ref ${params.ref_genome} \\
        --cpu ${task.cpus} \\
        --out_vcf ${sample_id}_filtered.vcf \\
        --out_pileup ${sample_id}_pileup.csv \\
        --min_depth 10 \\
        --threshold 0.2
    """
}






# ///////////////////////////////////////  corect
process parse_variant_qc {
    tag "$sample_id"

    input:
    tuple val(sample_id), path(vcf_file), path(vcf_index), path(bam_file)
    path ref_genome

    output:
    tuple val(sample_id), path("${sample_id}.filtered.vcf"), path("${sample_id}_pileup.csv")

    publishDir "${params.result_dir}/${sample_id}", mode: 'copy'

    script:
    """
    # Décompresser le fichier VCF pour qu'il soit lisible par le script
    gunzip -c ${vcf_file} > ${sample_id}.vcf

    # Exécuter le script Python avec le VCF non compressé
    python3 ${params.variant_qc_script} \\
        -b ${bam_file} \\
        -f ${ref_genome} \\
        -v ${sample_id}.vcf \\
        -ov ${sample_id}.filtered.vcf \\
        -op ${sample_id}_pileup.csv \\
        # -c ${par







        *////////////////////////////////////////////////////////////////////
        //////////////////////////////////////////////////////////////

        process parse_fastq_qc {
    tag "$sample_id"

    input:
    tuple val(sample_id), path(trimmed_fastq)

    output:
    tuple val(sample_id), path("fastq_qc_${sample_id}.tar.gz")

    publishDir "${params.result_dir ?: './results'}/${sample_id}/qc_fastq", mode: 'copy'

    script:
    """
    set -e
    echo "🔍 Traitement de : ${sample_id}"
    mkdir -p output_${sample_id}

    # Vérifie que le fichier FASTQ compressé existe
    if [ ! -s ${trimmed_fastq} ]; then
        echo "❌ Fichier FASTQ vide ou inexistant : ${trimmed_fastq}"
        exit 1
    fi

    # Décompression du fichier FASTQ
    gunzip -c ${trimmed_fastq} > ${sample_id}_trimmed.fastq

    # Exécution du script Python
    python3 ${params.fastq_qc_script} \\
        --input ${sample_id}_trimmed.fastq \\
        --output output_${sample_id} \\
        --sample ${sample_id}

    echo "📁 Fichiers générés :"
    ls -lh output_${sample_id}

    # Création d’une archive contenant tous les fichiers de sortie
    tar -czf fastq_qc_${sample_id}.tar.gz -C output_${sample_id} .

    # Nettoyage temporaire
    rm -f ${sample_id}_trimmed.fastq
    """
}



/////////////////////////////////////////corect 1
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



****************************************************corect 2
process parse_fastq_qc {
    tag "$sample_id"

    input:
    tuple val(sample_id), path(trimmed_fastq)

    // On récupère tout le dossier output_<sample_id>
    output:
    tuple val(sample_id), path("output_${sample_id}")

    // On copie « à plat » tous les fichiers du dossier output_<sample_id>
    publishDir "${params.result_dir ?: './results'}/${sample_id}/qc_fastq",
               mode: 'copy',
               flatten: true

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

    python3 ${params.fastq_qc_script} \\
        --input ${sample_id}_trimmed.fastq \\
        --output output_${sample_id} \\
        --sample ${sample_id}

    echo "📁 Fichiers générés :"
    ls -lh output_${sample_id}

    # Nettoyage du FASTQ décompressé
    rm -f ${sample_id}_trimmed.fastq
    """
}