import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Paramètres
base_path = "./results"
genome_max_pos = 3200
low_coverage_threshold = 10

for subdir in sorted(os.listdir(base_path)):
    subpath = os.path.join(base_path, subdir)
    if os.path.isdir(subpath) and subdir.startswith("barcode"):

        bed_file = os.path.join(subpath, f"{subdir}.sorted.coverage.bed")
        if not os.path.isfile(bed_file):
            continue

        # Lire le fichier
        df = pd.read_csv(bed_file, sep="\t", header=None, names=["chrom", "start", "end", "coverage"])
        df = df[(df["end"] >= 1) & (df["start"] <= genome_max_pos)].copy()

        if df.empty:
            continue

        # Couverture base à base
        coverage_vector = np.zeros(genome_max_pos)
        for _, row in df.iterrows():
            for i in range(row["start"], min(row["end"], genome_max_pos)):
                coverage_vector[i - 1] = row["coverage"]

        # Moyenne pondérée
        df["length"] = df["end"] - df["start"]
        weighted_mean = (df["coverage"] * df["length"]).sum() / df["length"].sum()

        # Tracer area plot
        plt.figure(figsize=(14, 5))
        x = np.arange(1, genome_max_pos + 1)
        y = coverage_vector

        plt.fill_between(x, y, color='skyblue', alpha=0.5, label='Couverture')
        plt.plot(x, y, color='blue', linewidth=0.8)

        # Lignes seuils
        plt.axhline(y=low_coverage_threshold, color='red', linestyle='--', label=f"Seuil faible ({low_coverage_threshold})")
        plt.axhline(y=weighted_mean, color='green', linestyle='-', label=f"Moyenne : {weighted_mean:.2f}")

        plt.title(f"Couverture génomique (Modèle 2) – {subdir}")
        plt.xlabel("Position génomique (bp)")
        plt.ylabel("Couverture")
        plt.ylim(bottom=0)
        plt.legend()
        plt.tight_layout()

        # Sauvegarde dans dossier graphs/barcodeXX
        outdir = os.path.join(base_path, "graphs", subdir)
        os.makedirs(outdir, exist_ok=True)
        plt.savefig(os.path.join(outdir, f"{subdir}_area_plot.png"))
        plt.close()
        print(f"✅ Sauvegardé : {outdir}/{subdir}_area_plot.png")
