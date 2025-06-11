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












import os
import glob
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

sns.set(style="whitegrid")

# === Dossiers ===
input_dir = "results"
graphs_dir = os.path.join(input_dir, "graphs_global")
os.makedirs(graphs_dir, exist_ok=True)

# === Lecture fichiers per_read_stats.tsv ===
files = glob.glob(f"{input_dir}/barcode*/read_alignment_stats/*_read_alignment_stats/per_read_stats.tsv")
df_all = []

for file_path in files:
    try:
        df = pd.read_csv(file_path, sep="\t")
        barcode = file_path.split("/")[1]
        df["Barcode"] = barcode
        df["Mapped"] = df["Mapping_Quality"].apply(lambda x: "Mapped" if x > 0 else "Unmapped")
        df_all.append(df)
    except Exception as e:
        print(f"❌ Erreur fichier : {file_path} → {e}")

if not df_all:
    raise ValueError("Aucun fichier per_read_stats.tsv trouvé.")
df_all = pd.concat(df_all, ignore_index=True)

# === Fonctions de graphique ===
def plot_density(data, column, title, xlabel, filename, hue="Barcode"):
    plt.figure(figsize=(8, 5))
    sns.kdeplot(data=data, x=column, hue=hue, linewidth=1.5, bw_adjust=0.8)
    plt.title(title)
    plt.xlabel(xlabel)
    plt.ylabel("Densité")
    plt.ylim(0, 1)
    plt.tight_layout()
    path = os.path.join(graphs_dir, filename)
    plt.savefig(path)
    plt.close()
    return filename

def plot_mapped_bar(data, filename):
    bar = data.groupby("Barcode")["Mapped"].value_counts(normalize=True).unstack().fillna(0) * 100
    bar = bar[["Mapped", "Unmapped"]] if "Unmapped" in bar.columns else bar
    bar.plot(kind="barh", stacked=True, color=["green", "red"], figsize=(8, 5))
    plt.title("5. Proportion reads mappés / unmappés")
    plt.xlabel("Proportion (%)")
    plt.tight_layout()
    path = os.path.join(graphs_dir, filename)
    plt.savefig(path)
    plt.close()
    return filename

# === Génération des 8 premières figures ===
fig1 = plot_density(df_all, "GC_content", "1. Composition en GC", "GC (%)", "fig1_gc_content.png")
fig2 = plot_density(df_all, "Length", "2. Longueur des reads", "Longueur (bp)", "fig2_read_length.png")
fig3 = plot_density(df_all, "Avg_Quality", "3. Score qualité de séquençage", "Qualité (Phred)", "fig3_avg_quality.png")
fig4 = plot_density(df_all, "Mapping_Quality", "4. Score qualité mapping", "Mapping Quality (Phred)", "fig4_mapping_quality.png")
fig5 = plot_mapped_bar(df_all, "fig5_mapped_barplot.png")
fig6 = plot_density(df_all, "GC_content", "6. GC Mapped vs Unmapped", "GC (%)", "fig6_gc_mapped_unmapped.png", hue="Mapped")
fig7 = plot_density(df_all, "Length", "7. Longueur Mapped vs Unmapped", "Longueur (bp)", "fig7_len_mapped_unmapped.png", hue="Mapped")
fig8 = plot_density(df_all, "Avg_Quality", "8. Qualité Mapped vs Unmapped", "Score qualité", "fig8_qual_mapped_unmapped.png", hue="Mapped")

# === Lecture des fichiers mapped_unmapped.txt ===
mapped_dict = {}
mapped_files = glob.glob(f"{input_dir}/barcode*/read_alignment_stats/*_read_alignment_stats/*mapped_unmapped.txt")

for file in mapped_files:
    try:
        barcode = file.split("/")[1]
        with open(file, "r") as f:
            lines = f.readlines()
            values = [int(l.split("+")[0].strip()) for l in lines if "mapped" in l.lower() and not "primary" in l.lower()]
            mapped = values[0] if len(values) > 0 else 0
            unmapped = values[1] if len(values) > 1 else 0
            mapped_dict[barcode] = {"Mapped": mapped, "Unmapped": unmapped}
    except Exception as e:
        print(f"⚠️ Erreur fichier {file} → {e}")

df_map_txt = pd.DataFrame.from_dict(mapped_dict, orient="index")
df_map_txt["Total"] = df_map_txt["Mapped"] + df_map_txt["Unmapped"]
df_map_txt["Mapped %"] = df_map_txt["Mapped"] / df_map_txt["Total"] * 100
df_map_txt["Unmapped %"] = df_map_txt["Unmapped"] / df_map_txt["Total"] * 100

# === Figure 9 depuis TXT ===
fig9 = "fig9_mapped_txt_barplot.png"
fig9_path = os.path.join(graphs_dir, fig9)
df_map_txt[["Mapped %", "Unmapped %"]].plot(kind="barh", stacked=True, color=["limegreen", "salmon"], figsize=(8, 5))
plt.title("9. Proportion reads (fichiers .txt)")
plt.xlabel("Proportion (%)")
plt.ylabel("Barcode")
plt.tight_layout()
plt.savefig(fig9_path)
plt.close()

# === Création du rapport HTML ===
output_html = os.path.join(input_dir, "rapport_HBV.html")
html = f"""
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Rapport Séquençage HBV</title>
    <style>
        body {{ font-family: Arial, sans-serif; padding: 20px; }}
        h1 {{ color: #2E8B57; text-align: center; }}
        h2 {{ color: #000000; margin-top: 40px; }}
        h3 {{ color: #444; margin-top: 30px; }}
        img {{ display: block; margin: 0 auto; width: 700px; border: 1px solid #ccc; padding: 5px; background: #f9f9f9; }}
        footer {{ margin-top: 50px; color: gray; text-align: center; }}
    </style>
</head>
<body>
<h1>Rapport Global – Analyse de Séquençage Hépatite B</h1>

<h2>Qualité du séquençage</h2>
<h3>1. Composition en GC</h3><img src="{fig1}">
<h3>2. Longueur des reads</h3><img src="{fig2}">
<h3>3. Score qualité de séquençage</h3><img src="{fig3}">
<h3>4. Score qualité du mapping</h3><img src="{fig4}">

<h2>Qualité du mapping</h2>
<h3>5. Proportion mapped / unmapped (calculé)</h3><img src="{fig5}">
<h3>6. GC mapped vs unmapped</h3><img src="{fig6}">
<h3>7. Longueur mapped vs unmapped</h3><img src="{fig7}">
<h3>8. Qualité mapped vs unmapped</h3><img src="{fig8}">
<h3>9. Proportion mapped / unmapped (fichier TXT)</h3><img src="{fig9}">

<footer>
    <p>Rapport généré automatiquement – Pipeline HBV – Fatemeh Kazemi</p>
</footer>
</body>
</html>
"""

with open(output_html, "w", encoding="utf-8") as f:
    f.write(html)

print(f"✅ Rapport HTML généré avec 9 figures : {output_html}")










# //////////////////////////////////////////////////////////////////

import os
import glob
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

sns.set(style="whitegrid")

# ✅ Correction du chemin depuis src/
input_dir = "../results"
output_html = os.path.join(input_dir, "rapport_HBV.html")
graphs_dir = os.path.join(input_dir, "graphs_global")
os.makedirs(graphs_dir, exist_ok=True)

# 🔍 Chargement des fichiers per_read_stats.tsv
files = glob.glob(f"{input_dir}/barcode*/read_alignment_stats/*_read_alignment_stats/per_read_stats.tsv")

df_all = []
for file_path in files:
    try:
        df = pd.read_csv(file_path, sep="\t")
        barcode = file_path.split("/")[2]
        df["Barcode"] = barcode
        df["Mapped"] = df["Mapping_Quality"].apply(lambda x: "Mapped" if x > 0 else "Unmapped")
        df_all.append(df)
    except Exception as e:
        print(f"❌ Erreur fichier : {file_path} → {e}")

if not df_all:
    raise ValueError("Aucun fichier per_read_stats.tsv trouvé.")

df_all = pd.concat(df_all, ignore_index=True)

# 📈 Fonction densité
def plot_density(data, column, title, xlabel, filename, hue="Barcode"):
    plt.figure(figsize=(8, 5))
    sns.kdeplot(data=data, x=column, hue=hue, linewidth=1.5, bw_adjust=0.8)
    plt.title(title)
    plt.xlabel(xlabel)
    plt.ylabel("Densité")
    plt.ylim(0, None)
    plt.tight_layout()
    path = os.path.join(graphs_dir, filename)
    plt.savefig(path)
    plt.close()
    return path

# 📊 Barplot calculé mapped/unmapped
def plot_mapped_bar(data, filename):
    bar = data.groupby("Barcode")["Mapped"].value_counts(normalize=True).unstack().fillna(0) * 100
    bar = bar[["Mapped", "Unmapped"]] if "Unmapped" in bar.columns else bar
    bar.plot(kind="barh", stacked=True, color=["green", "red"], figsize=(8, 5))
    plt.title("5. Proportion reads mappés / unmappés")
    plt.xlabel("Proportion (%)")
    plt.tight_layout()
    path = os.path.join(graphs_dir, filename)
    plt.savefig(path)
    plt.close()
    return path

# 📊 Mapped depuis TXT
mapped_dict = {}
txt_files = glob.glob(f"{input_dir}/barcode*/read_alignment_stats/*_read_alignment_stats/*mapped_unmapped.txt")

for file in txt_files:
    try:
        barcode = file.split("/")[2]
        with open(file) as f:
            lines = f.readlines()
            mapped = int(lines[0].split()[0])
            unmapped = int(lines[1].split()[0])
            mapped_dict[barcode] = {"Mapped": mapped, "Unmapped": unmapped}
    except Exception as e:
        print(f"⚠️ Erreur fichier {file} → {e}")

df_map_txt = pd.DataFrame.from_dict(mapped_dict, orient="index")
df_map_txt["Total"] = df_map_txt["Mapped"] + df_map_txt["Unmapped"]
df_map_txt["Mapped %"] = df_map_txt["Mapped"] / df_map_txt["Total"] * 100
df_map_txt["Unmapped %"] = df_map_txt["Unmapped"] / df_map_txt["Total"] * 100

# 📊 Graphique depuis TXT
fig9_path = os.path.join(graphs_dir, "fig9_mapped_txt_barplot.png")
df_map_txt[["Mapped %", "Unmapped %"]].plot(kind="barh", stacked=True, color=["limegreen", "salmon"], figsize=(8, 5))
plt.title("9. Proportion reads (fichier TXT)")
plt.xlabel("Proportion (%)")
plt.tight_layout()
plt.savefig(fig9_path)
plt.close()

# ✅ Génération des 8 autres graphiques
fig1 = plot_density(df_all, "GC_content", "1. Composition en GC", "GC (%)", "fig1_gc_content.png")
fig2 = plot_density(df_all, "Length", "2. Longueur des reads", "Longueur (bp)", "fig2_read_length.png")
fig3 = plot_density(df_all, "Avg_Quality", "3. Score qualité de séquençage", "Score qualité (Phred)", "fig3_avg_quality.png")
fig4 = plot_density(df_all, "Mapping_Quality", "4. Score qualité mapping", "Mapping Quality (Phred)", "fig4_mapping_quality.png")
fig5 = plot_mapped_bar(df_all, "fig5_mapped_barplot.png")
fig6 = plot_density(df_all, "GC_content", "6. GC Mapped vs Unmapped", "GC (%)", "fig6_gc_mapped_unmapped.png", hue="Mapped")
fig7 = plot_density(df_all, "Length", "7. Longueur Mapped vs Unmapped", "Longueur (bp)", "fig7_len_mapped_unmapped.png", hue="Mapped")
fig8 = plot_density(df_all, "Avg_Quality", "8. Qualité Mapped vs Unmapped", "Score qualité", "fig8_qual_mapped_unmapped.png", hue="Mapped")

# 📝 HTML rapport final
html = f"""
<html>
<head><meta charset='UTF-8'><title>Rapport Séquençage HBV</title></head>
<body style="font-family:sans-serif; padding:20px;">
<h1 style="color:#2E8B57;">Rapport Global – Analyse de Séquençage Hépatite B</h1>

<h2>Qualité du séquençage</h2>
<h3>1. Composition en GC</h3><div style='text-align:center'><img src="{fig1}" width="700"></div><br>
<h3>2. Longueur des reads</h3><div style='text-align:center'><img src="{fig2}" width="700"></div><br>
<h3>3. Score qualité de séquençage</h3><div style='text-align:center'><img src="{fig3}" width="700"></div><br>
<h3>4. Score qualité du mapping</h3><div style='text-align:center'><img src="{fig4}" width="700"></div><br>

<h2>Qualité du mapping</h2>
<h3>5. Proportion mapped / unmapped (calculé)</h3><div style='text-align:center'><img src="{fig5}" width="700"></div><br>
<h3>6. GC mapped vs unmapped</h3><div style='text-align:center'><img src="{fig6}" width="700"></div><br>
<h3>7. Longueur mapped vs unmapped</h3><div style='text-align:center'><img src="{fig7}" width="700"></div><br>
<h3>8. Qualité mapped vs unmapped</h3><div style='text-align:center'><img src="{fig8}" width="700"></div><br>
<h3>9. Proportion mapped / unmapped (fichier TXT)</h3><div style='text-align:center'><img src="{fig9_path}" width="700"></div><br>

<footer style="margin-top:50px; color:gray;">
<p>Rapport généré automatiquement – Pipeline HBV – Fatemeh Kazemi</p>
</footer>
</body>
</html>
"""

with open(output_html, "w", encoding="utf-8") as f:
    f.write(html)

print(f"✅ Rapport HTML généré : {output_html}")










###########################################################
process parse_read_align {

    input:
    tuple val(sample_id), path(bam_file)

    output:
    path("${sample_id}_read_alignment_stats/")

    publishDir "${params.result_dir ?: './results'}/${sample_id}/read_alignment_stats", mode: 'copy'

    script:
    """
    mkdir -p ${sample_id}_read_alignment_stats

    # 1. Nombre de reads mappés et unmappés
    samtools flagstat ${bam_file} > ${sample_id}_read_alignment_stats/mapped_unmapped.txt

    # 2. Statistiques par read
    samtools view ${bam_file} | awk '
    BEGIN {
        OFS="\\t"
        print "Read_ID", "Length", "GC_content", "Avg_Quality", "Mapping_Quality"
    }
    {
        read_id = \$1
        seq = \$10
        qual = \$11
        mapq = \$5

        len = length(seq)
        
        # Calcul GC content
        gc = gsub(/[GCgc]/, "", seq)
        gc_content = len > 0 ? (gc / len) * 100 : 0

        # Calcul average quality
        total_q = 0
        for (i = 1; i <= length(qual); i++) {
            q = substr(qual, i, 1)
            total_q += (ord(q) - 33)
        }
        avg_qual = len > 0 ? total_q / len : 0

        printf "%s\\t%d\\t%.2f\\t%.2f\\t%d\\n", read_id, len, gc_content, avg_qual, mapq
    }

    # Fonction ord() en awk pour qualité
    function ord(c) {
        return index("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", c) + 32
    }

    ' > ${sample_id}_read_alignment_stats/per_read_stats.tsv
    """
}



process parse_read_align {

  tag "${sample}"

  input:
    path bam_file
    val sample
    val cpu
  output:
    path "${sample}_read_align_stats", emit: parsed_stats

  script:
    """
    mkdir ${sample}_read_align_stats
    parse_read_align \\
      -i ${bam_file} \\
      -o ${sample}_read_align_stats \\
      -c ${cpu} \\
      -s ${sample}
    """
}