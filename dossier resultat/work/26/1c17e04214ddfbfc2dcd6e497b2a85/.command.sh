#!/bin/bash -ue
# Aller à la racine du projet (un niveau au-dessus de src/)
cd /home/etudiant/fatemeh/hbv_pipeline/src/..

# S’assurer que le dossier de sortie existe
mkdir -p ../results/reports

# Lancer le rendu RMarkdown : on pointe sur le Rmd qui se trouve dans src/
Rscript -e "rmarkdown::render(
  'src/rapport_final.Rmd',
  output_dir='../results/reports'
)"

# Copier le HTML généré dans le workdir pour que Nextflow le récupère
cp ../results/reports/rapport_final.html .
