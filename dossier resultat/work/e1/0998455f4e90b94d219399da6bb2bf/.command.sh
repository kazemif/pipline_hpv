#!/bin/bash -ue
# Aller à la racine du projet (un niveau au-dessus de src/)
cd /home/etudiant/fatemeh/hbv_pipeline/src/..

# Créer le dossier de sortie
mkdir -p ../results/reports

# Rendre le RMarkdown en HTML (tout sur une seule ligne !)
Rscript -e "rmarkdown::render('src/rapport_final.Rmd', output_dir='../results/reports')"

# Copier le HTML généré pour que Nextflow le publie
cp ../results/reports/rapport_final.html .
