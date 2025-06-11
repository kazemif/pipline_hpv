#!/bin/bash -ue
# se placer dans la racine du projet pour retrouver 'src/results'
cd $PWD

# créer le dossier si besoin
mkdir -p ../results/reports

# rendre le RMarkdown en HTML
Rscript -e "rmarkdown::render('rapport_final.Rmd', output_dir='../results/reports')"

# ramener le HTML dans le workdir pour que Nextflow le publie
cp ../results/reports/rapport_final.html .
