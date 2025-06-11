process consensus_generation {

    input:
    tuple val(sample_id), path(vcf), path(tbi), path(ref_genome), path(lowcov_bed)

    output:
    path("${sample_id}.consensus.fa")
    path("${sample_id}.tmp.fa")
    path("${sample_id}.lowcov.valid.bed") // exporté pour vérification si tu veux

    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    set -e

    # Étape 1 : Générer la séquence consensus à partir du VCF
    bcftools consensus -f ${ref_genome} ${vcf} > ${sample_id}.tmp.fa

    # Étape 2 : Filtrer le fichier BED pour garder uniquement les lignes valides
    awk '\$2 < \$3' ${lowcov_bed} > ${sample_id}.lowcov.valid.bed

    # Étape 3 : Masquer les régions à faible couverture
    bedtools maskfasta -fi ${sample_id}.tmp.fa -bed ${sample_id}.lowcov.valid.bed -fo ${sample_id}.consensus.fa
    """
}

