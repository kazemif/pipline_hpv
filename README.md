# 🧬 Pipeline d’analyse HBV – Nextflow + RMarkdown

Ce projet implémente un pipeline bioinformatique complet pour analyser des lectures FASTQ issues de séquençage HBV (virus de l’hépatite B).  
Il inclut le prétraitement, l’alignement, le contrôle qualité, le calcul de couverture, l’appel de variants et la génération automatique d’un **rapport HTML interactif**.

📌 *Le dossier `results/` est créé automatiquement pour stocker tous les résultats.*

---

## 📚 Sommaire

- [Fonctionnalités](#-fonctionnalités-principales)
- [Structure du projet](#-structure-du-projet)
- [Installation](#-installation)
- [Exécution](#-exécution)
- [Rapport HTML](#-rapport-html)
- [Exemple de sortie](#-exemple-de-sortie-)
- [.gitignore](#-gitignore)
- [Dépendances](#-dépendances)
- [Résumé](#-résumé)
- [Auteur](#-auteure)

---

## 🧪 Fonctionnalités principales

- Fusion automatique des fichiers FASTQ par barcode
- Trimming avec `fastp`
- Alignement sur le génome de référence avec `minimap2`
- Indexation BAM (`samtools`)
- Calcul de couverture et profondeur
- Appel de variants avec `bcftools`
- Génération de séquence consensus
- Création d’un rapport HTML interactif avec `RMarkdown`

---

🛠️ Pour exécuter le pipeline :
bash

- git clone https://github.com/kazemif/pipline_hpv.git
- cd pipline_hpv
- conda env create -f environment.yml
- conda activate hbv_pipeline
- ./run_pipeline.sh


## 📁 Structure du projet



hbv_pipeline/
- ├── data_test/ # Données de test avec barcode01 à barcode16
- ├── results/ # Résultats générés automatiquement
- │ ├── barcode01/
- │ ├── ...
- │ └── reports/ # Rapport HTML final ici
- ├── src/
- │ ├── main.nf # Pipeline Nextflow
- │ ├── script_pipeline.py # Script principal Python
- │ ├── rapport_final.Rmd # Rapport RMarkdown
- │ └── fonctions_globales.R # Fonctions pour les graphiques QC
- ├── tools/
- │ └── python/
- │ ├── parse_fastq/
- │ ├── parse_read_align/
- │ └── parse_variant/
- ├── environment.yml
- └── README.md



---

## 🛠️ Installation

1. Cloner ce dépôt :
```bash
git clone https://github.com/fatemeh/hbv_pipeline.git
cd hbv_pipeline


##2. Créer l’environnement Conda :

conda env create -f environment.yml
conda activate hbv_pipeline


🚀 Exécution

chmod +x run_pipeline.sh
./run_pipeline.sh


##Méthode avancée avec arguments personnalisés :

python3 src/script_pipeline.py \
  --input data_test/hbv \
  --result_dir results \
  --rmd src/rapport_final.Rmd \
  --output_dir results/reports

📌 Le dossier results/ sera automatiquement créé pour contenir tous les résultats, organisés par barcode.



📄 Rapport HTML

Le rapport contient :

Composition en GC (reads bruts)

Longueur des reads (bruts)

Score qualité Phred (bruts)

Score qualité par position

Composition GC des reads alignés

Proportion reads mappés / unmappés

Longueur des reads mappés

Qualité du mapping

Score Phred des reads mappés

Heatmap de la couverture

Tableau résumé de la couverture


📊 Exemple de sortie
Le pipeline génère automatiquement :

Fichiers BAM, VCF, BED

Séquences consensus au format FASTA

Statistiques qualité (parse_fastq_qc, parse_variant_qc)

Rapport HTML final avec graphiques



❌ .gitignore recommandé

results/
data_test/
*.fastq.gz
*.bam
*.vcf
*.html
*.zip
*.tar.gz
__pycache__/



📦 Dépendances
Python 3.x

Nextflow ≥ 24.10.0

R avec les packages :

ggplot2

dplyr

readr

tidyr

plotly

knitr

kableExtra

stringr

scales

➡️ Recommandé : installation via conda avec le fichier environment.yml.


✅ Résumé pour bien démarrer
Exécuter : run_pipeline.sh

Environnement : environment.yml

Rapport : rapport_final.Rmd

Documentation : README.md



💡 Pour relancer le pipeline proprement :
 rm -rf results/


🙋‍♀️ Auteure
Fatemeh Kazemi
Master 2 Bioinformatique – Sorbonne Université
GitHub : @kazemif

