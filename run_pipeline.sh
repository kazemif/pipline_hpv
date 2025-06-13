#!/bin/bash

#  Lancer le pipeline Python (avec Nextflow et RMarkdown)

# (Facultatif : active l'environnement Conda si besoin)
# source ~/miniconda3/etc/profile.d/conda.sh
# conda activate hbv_pipeline

# Lancer le pipeline
python3 src/script_pipeline.py \
  --input data_test/hbv \
  --result_dir results \
  --rmd src/rapport_final.Rmd \
  --output_dir results/reports

