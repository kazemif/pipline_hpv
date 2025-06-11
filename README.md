# Pipeline d’analyse HBV – Nextflow + RMarkdown

Ce projet implémente un pipeline bioinformatique complet pour analyser des lectures FASTQ issues de séquençage HBV (hépatite B).  
Il inclut le prétraitement, l’alignement, le QC, la couverture, l’appel de variants et la génération automatique d’un **rapport HTML interactif**.

...

📌 *Le dossier `results/` sera créé automatiquement à la racine pour stocker tous les résultats.*

...
# Pipeline d’analyse HBV – Nextflow + RMarkdown

Ce projet implémente un pipeline bioinformatique complet pour analyser des lectures FASTQ issues de séquençage HBV (hépatite B).  
Il inclut le prétraitement, l’alignement, le QC, la couverture, l’appel de variants et la génération automatique d’un **rapport HTML interactif**.

---

## 📁 Structure du projet

hbv_pipeline/
├── data_test/ # Données d'exemple avec sous-dossiers barcode01 à barcode16
├── results/ # Résultats générés automatiquement
│ ├── barcode01/
│ ├── ...
│ └── reports/ # Rapport HTML final ici
├── src/
│ ├── script_pipeline.py # Script Python principal
│ ├── main.nf # Pipeline Nextflow
│ ├── rapport_final.Rmd # Rapport HTML généré avec RMarkdown
│ └── fonctions_globales.R # Fonctions pour les graphiques QC



---

## 🚀 Exécution du pipeline

Lancez le pipeline et générez le rapport HTML automatiquement avec la commande suivante :

```bash
cd ~/fatemeh/hbv_pipeline

python3 src/script_pipeline.py \
  --input data_test/hbv \
  --rmd src/rapport_final.Rmd \
  --output_dir results/reports






Contenu du rapport HTML
Le rapport contient :

Composition en GC (reads bruts)

Longueur des reads (bruts)

Score qualité Phred (bruts)

Score par position

GC des reads alignés

Proportions reads mappés / unmappés

Longueur reads mappés

Qualité du mapping

Score Phred des reads mappés

Heatmap de la couverture

Tableau résumé de couverture


Astuce
Pour supprimer tous les résultats et relancer le pipeline proprement :

bash
Copier
Modifier
rm -rf results/

🙋‍♀️ Auteure
Fatemeh Kazemi
Université Sorbonne – M2 Bioinformatique


