#!/bin/bash -ue
# On se trouve automatiquement dans un sous-dossier temporaire (work/…).
# Nextflow a copié ici :
#   - le dossier 'results/' (avec tout son contenu QC/plots)
#   - le fichier 'rapport_final.Rmd'
#   - le fichier 'fonctions_globales.R'
#
# On crée un dossier temporaire pour stocker le HTML final :
mkdir -p work_reports

# On lance directement Rscript pour rendre le Rmd en fixant les variables d’environnement :
Rscript -e "         Sys.setenv(BASE_DIR_RMD='results');         Sys.setenv(OUTPUT_DIR_RMD='work_reports');         rmarkdown::render(basename('rapport_final.Rmd'), output_dir='work_reports')     "

# On copie le HTML généré vers la racine du workdir pour que Nextflow le publie :
cp work_reports/rapport_final.html ./rapport_final.html
