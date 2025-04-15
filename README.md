# HBV Pipeline (Nextflow DSL2)

Ce pipeline bioinformatique en Nextflow permet de traiter des fichiers FASTQ , allant de la fusion des reads jusqu'à la génération d'une séquence consensus. Il est conçu pour être exécuté facilement grâce à un script Python ou Bash.

## Fonctionnalités principales 🌐

- Détection automatique du type d'entrée (archive, fichier unique, dossier plat ou multiplex)
- Fusion et trimming des reads
- Contrôle qualité des FASTQ
- Mapping contre un génome de référence
- Indexation et calcul de couverture BAM
- Appel de variants et filtrage
- Génération de séquences consensus par barcode

## Prérequis ⚡

- [Nextflow](https://www.nextflow.io/)
- Python 3 (si vous utilisez `run_pipeline.py`)
- Génome de référence FASTA (ex: `Ref/sequence.fasta`)
- Fichier d'amorce (ex: `primer/HBV_primer.fasta`)

## Structure recommandée du projet 📁

```
.
├── data_test/             # Données d'exemple
│   └── hbv/            # FASTQ.gz (plat ou multiplex)
├── Ref/                   # Contient sequence.fasta (référence)
├── primer/                # Contient HBV_primer.fasta
├── modules/               # Modules Nextflow DSL2
├── src/
│   ├── main.nf         # Pipeline principal
│   └── nextflow.config
├── run_pipeline.py        # Script de lancement Python
├── .gitignore             # Pour exclure les fichiers volumineux
└── results/               # Résultats générés
```

## Utilisation 

### 1. Avec Python (recommandé)
```bash
python3 run_pipeline.py data_test/hbv Ref/sequence.fasta results/
```

### 2. Avec Bash (alternatif)
```bash
chmod +x run_pipeline.sh
./run_pipeline.sh data_test/hbv Ref/sequence.fasta results/
```

## Exemple de sortie 📊
Le pipeline génère :
- BAM, VCF et fichiers de couverture par barcode
- Fichiers BED de faible couverture
- Séquences consensus FASTA (1 par barcode)
- Statistiques QC (parse_fastq_qc, parse_variant_qc...)

## Fichier `.gitignore` ❌
Pour éviter de pousser des fichiers volumineux sur GitHub, ajoutez :
```
results/
data_test/
*.fastq.gz
*.bam
*.vcf
*.html
*.zip
*.tar.gz
__pycache__/
```

## Conseils de bonne pratique ✅
- Ne pas obliger l'utilisateur à modifier manuellement le script.
- Prévoir un script d’exécution (comme `run_pipeline.py`) acceptant des arguments.
- Inclure un README clair pour faciliter l'utilisation.
- Ajouter le dossier `Ref/` dans GitHub pour inclure le génome référentiel.

## Auteur 👤
Fatemeh Kazemi  
M2 Bioinformatique - Sorbonne Université
