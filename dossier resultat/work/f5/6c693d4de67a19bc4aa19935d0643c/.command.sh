#!/bin/bash -ue
# Aller à la racine du projet
     cd /home/etudiant/fatemeh/hbv_pipeline/src/..

     # Créer le répertoire de sortie
     mkdir -p ../results/reports

-    # Lancer le rendu RMarkdown :
-    Rscript -e "rmarkdown::render(
-      'src/rapport_final.Rmd',
-      output_dir='../results/reports'
-    )"
+    # Rendre le RMarkdown en HTML (tout sur une ligne !)
+    Rscript -e "rmarkdown::render('src/rapport_final.Rmd', output_dir='../results/reports')"

     # Copier le HTML pour Nextflow
     cp ../results/reports/rapport_final.html .
