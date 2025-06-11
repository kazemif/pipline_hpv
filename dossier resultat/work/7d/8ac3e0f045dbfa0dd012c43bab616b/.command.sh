#!/bin/bash -ue
# Aller à la racine du projet (là où se trouve rapport_final.Rmd)
cd /home/etudiant/fatemeh/hbv_pipeline/src

# S’assurer que le dossier de sortie existe
mkdir -p ../results/reports

# Lancer RMarkdown : 
Rscript -e "rmarkdown::render(
  'rapport_final.Rmd',
  output_dir='../results/reports'
)"

# Copier le HTML généré pour que Nextflow le récupère
cp ../results/reports/rapport_final.html .
