#!/bin/bash -ue
set -e

# Assurer que les modules Python sont trouvés
export PYTHONPATH=$(dirname /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py)

# Exécuter le script d’analyse de variant
python3 /home/etudiant/fatemeh/stage_fatemeh_2025/tools/Python/parse_variant/src/parse_variant/main.py \
    --vcf barcode14.sorted.vcf.gz \
    --bam ./results/barcode14/barcode14.sorted.bam \
    --ref /home/etudiant/fatemeh/hbv_pipeline/Ref/sequence.fasta \
    --cpu 1 \
    --out_vcf barcode14_filtered.vcf \
    --out_pileup barcode14_pileup.csv \
    --min_depth 10 \
    --threshold 0.2
