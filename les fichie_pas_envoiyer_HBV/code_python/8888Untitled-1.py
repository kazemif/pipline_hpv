
import pandas as pd
import glob
import os

# Trouver tous les fichiers variant_qc.csv
fichiers = glob.glob("results/barcode*/barcode*_variant_qc.csv")

# Liste pour stocker tous les DataFrames
liste_df = []

for fichier in fichiers:
    # Exemple: results/barcode02/barcode02_variant_qc.csv
    sample_id = os.path.basename(fichier).split('_')[0]  # barcode02
    df = pd.read_csv(fichier)
    df["sample_id"] = sample_id
    liste_df.append(df)

# Fusionner tous les DataFrames
df_total = pd.concat(liste_df, ignore_index=True)

# Sauvegarder dans un fichier unique
df_total.to_csv("variant_qc_total.csv", index=False)

print("✅ Fusion terminée. Fichier sauvegardé : variant_qc_total.csv")






import pandas as pd
import glob
import os

# Trouver tous les fichiers variant_qc.csv
fichiers = glob.glob("results/barcode*/barcode*_variant_qc.csv")

# Liste pour stocker tous les DataFrames
liste_df = []

for fichier in fichiers:
    # Exemple: results/barcode02/barcode02_variant_qc.csv
    sample_id = os.path.basename(fichier).split('_')[0]  # barcode02
    df = pd.read_csv(fichier)
    df["sample_id"] = sample_id
    liste_df.append(df)

# Fusionner tous les DataFrames
df_total = pd.concat(liste_df, ignore_index=True)

# Sauvegarder dans un fichier unique
df_total.to_csv("variant_qc_total.csv", index=False)

print("✅ Fusion terminée. Fichier sauvegardé : variant_qc_total.csv")













process parse_variant_qc {

    input:
    tuple val(sample_id), path(vcf_file)

    output:
    path("${sample_id}_variant_qc.csv")

    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    set -e

    # Extraction des colonnes CHROM, POS, DP
    # et filtrage sur profondeur ≥ 10
    bcftools query -f '%CHROM\\t%POS\\t[%DP]\\n' ${vcf_file} | awk '
    BEGIN {
        OFS = ","  # Séparateur CSV
        print "CHROM", "POS", "DP"
    }
    {
        dp = \$3 + 0
        if (dp >= 10)
            print \$1, \$2, dp
    }
    ' > ${sample_id}_variant_qc.csv
    """
}
**////////////////

import os
import pandas as pd
import matplotlib.pyplot as plt

# Paramètres
low_coverage_threshold = 10
genome_max_pos = 3200

# Dossier racine où sont les sous-dossiers barcodeXX
base_path = "./results"  # adapte si besoin

# Lister les sous-dossiers
for subdir in os.listdir(base_path):
    subpath = os.path.join(base_path, subdir)
    if os.path.isdir(subpath) and subdir.startswith("barcode"):

        # Chercher le fichier coverage.bed dans ce dossier
        coverage_file = os.path.join(subpath, f"{subdir}.sorted.coverage.bed")
        if not os.path.isfile(coverage_file):
            print(f"⚠️ Fichier manquant : {coverage_file}")
            continue

        print(f"📈 Graphe pour {subdir}")

        # Lire le fichier
        df = pd.read_csv(coverage_file, sep="\t", header=None, names=["chrom", "start", "end", "coverage"])
        df = df[(df["end"] >= 1) & (df["start"] <= genome_max_pos)].copy()

        if df.empty:
            print(f"❗ Aucune donnée dans {coverage_file}")
            continue

        df["length"] = df["end"] - df["start"]
        weighted_mean = (df["coverage"] * df["length"]).sum() / df["length"].sum()

        # Tracer le graphe
        plt.figure(figsize=(14, 5))
        for _, row in df.iterrows():
            color = 'red' if row["coverage"] < low_coverage_threshold else 'blue'
            plt.hlines(y=row["coverage"], xmin=row["start"], xmax=row["end"], color=color, linewidth=1)

        plt.axhline(y=low_coverage_threshold, color='red', linestyle='--', label=f"Seuil faible couverture ({low_coverage_threshold})")
        plt.axhline(y=weighted_mean, color='green', linestyle='-', label=f"Couverture moyenne : {weighted_mean:.2f}")
        plt.title(f"Couverture génomique – {subdir}")
        plt.xlabel("Position génomique (bp)")
        plt.ylabel("Couverture")
        plt.ylim(bottom=0)
        plt.legend()
        plt.tight_layout()

        # Sauvegarde dans le même dossier
        graph_dir = os.path.join("./results/graphs", subdir)
        os.makedirs(graph_dir, exist_ok=True)
        output_path = os.path.join(graph_dir, f"{subdir}_coverage_plot.png")

        plt.savefig(output_path)
        plt.close()
        print(f"✅ Image sauvegardée : {output_path}")

