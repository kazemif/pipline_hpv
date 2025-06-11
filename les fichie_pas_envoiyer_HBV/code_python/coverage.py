
import os
import pandas as pd
import matplotlib.pyplot as plt

# Paramètres
low_coverage_threshold = 10
genome_max_pos = 3200
base_path = "./results"

# Créer le dossier graphs s'il n'existe pas
os.makedirs(os.path.join(base_path, "graphs"), exist_ok=True)

# Lister tous les sous-dossiers commençant par barcode
for subdir in sorted(os.listdir(base_path)):
    subpath = os.path.join(base_path, subdir)
    if not (os.path.isdir(subpath) and subdir.startswith("barcode")):
        continue

    print(f"🔍 Analyse pour : {subdir}")
    graph_dir = os.path.join(base_path, "graphs", subdir)
    os.makedirs(graph_dir, exist_ok=True)

    ### 1. Analyse couverture (coverage.bed)
    coverage_file = os.path.join(subpath, f"{subdir}.sorted.coverage.bed")
    if os.path.exists(coverage_file):
        df_cov = pd.read_csv(coverage_file, sep="\t", header=None, names=["chrom", "start", "end", "coverage"])
        df_cov = df_cov[(df_cov["end"] >= 1) & (df_cov["start"] <= genome_max_pos)].copy()

        if not df_cov.empty:
            df_cov["length"] = df_cov["end"] - df_cov["start"]
            weighted_mean = (df_cov["coverage"] * df_cov["length"]).sum() / df_cov["length"].sum()

            plt.figure(figsize=(14, 5))
            for _, row in df_cov.iterrows():
                color = 'red' if row["coverage"] < low_coverage_threshold else 'blue'
                plt.hlines(y=row["coverage"], xmin=row["start"], xmax=row["end"], color=color, linewidth=1)

            plt.axhline(y=low_coverage_threshold, color='red', linestyle='--', label=f"Seuil faible ({low_coverage_threshold})")
            plt.axhline(y=weighted_mean, color='green', linestyle='-', label=f"Moyenne pondérée : {weighted_mean:.2f}")
            plt.title(f"📊 Couverture génomique – {subdir}")
            plt.xlabel("Position génomique (bp)")
            plt.ylabel("Couverture")
            plt.ylim(bottom=0)
            plt.legend()
            plt.tight_layout()

            plt.savefig(os.path.join(graph_dir, f"{subdir}_coverage_plot.png"))
            plt.close()
            print(f"✅ Graphe couverture enregistré pour {subdir}")

        else:
            print(f"⚠️ Données vides pour {coverage_file}")
    else:
        print(f"❌ Fichier non trouvé : {coverage_file}")

    ### 2. Analyse profondeur des variants (DP)
    variant_qc_file = os.path.join(subpath, f"{subdir}_variant_qc.csv")
    if os.path.exists(variant_qc_file):
        df_var = pd.read_csv(variant_qc_file)

        if not df_var.empty:
            plt.figure(figsize=(12, 4))
            plt.plot(df_var["POS"], df_var["DP"], marker='o', linestyle='-', color='purple')
            plt.axhline(y=low_coverage_threshold, color='red', linestyle='--', label=f"Seuil faible ({low_coverage_threshold})")
            plt.title(f"🔬 Profondeur des variants – {subdir}")
            plt.xlabel("Position du variant (POS)")
            plt.ylabel("Profondeur (DP)")
            plt.legend()
            plt.tight_layout()

            plt.savefig(os.path.join(graph_dir, f"{subdir}_variant_dp_plot.png"))
            plt.close()
            print(f"✅ Graphe profondeur variant enregistré pour {subdir}")
        else:
            print(f"⚠️ Données vides dans {variant_qc_file}")
    else:
        print(f"❌ Fichier non trouvé : {variant_qc_file}")
