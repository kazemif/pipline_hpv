#!/bin/bash -ue
# 1) Aller à la racine du projet (au-dessus de src/)
cd /home/etudiant/fatemeh/hbv_pipeline/src/..

# 2) Créer le dossier de sortie
mkdir -p results/reports

# 3) Rendre le RMarkdown (une seule ligne !)
Rscript -e "rmarkdown::render('src/rapport_final.Rmd', output_dir='results/reports')"

# 4) Copier le HTML pour Nextflow
cp results/reports/rapport_final.html .
