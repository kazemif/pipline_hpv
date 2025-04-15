process consensus_generation {

    input:
    tuple val(sample_id), path(vcf), path(tbi), path(ref_genome), path(lowcov_bed)

    output:
    path("${sample_id}.consensus.fa")
    path("${sample_id}.tmp.fa")  // on garde aussi le fichier temporaire

    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    set -e

    # Étape 1 : Générer la séquence consensus à partir du fichier VCF
    bcftools consensus -f ${ref_genome} ${vcf} > ${sample_id}.tmp.fa

    # Étape 2 : Masquer les régions de faible couverture avec bedtools
    bedtools maskfasta -fi ${sample_id}.tmp.fa -bed ${lowcov_bed} -fo ${sample_id}.consensus.fa

    # On NE supprime PAS le fichier temporaire ici
    """
}
