import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Paramètres
base_path = "./results"
genome_max_pos = 3200
output_path = os.path.join(base_path, "graphs", "global")
os.makedirs(output_path, exist_ok=True)

heatmap_matrix = []
barcode_labels = []

# Charger les données pour chaque barcode
for subdir in sorted(os.listdir(base_path)):
    subpath = os.path.join(base_path, subdir)
    if os.path.isdir(subpath) and subdir.startswith("barcode"):

        bed_file = os.path.join(subpath, f"{subdir}.sorted.coverage.bed")
        if not os.path.isfile(bed_file):
            continue

        df = pd.read_csv(bed_file, sep="\t", header=None, names=["chrom", "start", "end", "coverage"])
        df = df[(df["end"] >= 1) & (df["start"] <= genome_max_pos)].copy()

        # vecteur de 3200 positions, initialisé à 0
        coverage_vector = np.zeros(genome_max_pos)

        for _, row in df.iterrows():
            for i in range(row["start"], min(row["end"], genome_max_pos)):
                coverage_vector[i - 1] = row["coverage"]

        heatmap_matrix.append(coverage_vector)
        barcode_labels.append(subdir)

# Créer une matrice numpy
matrix = np.array(heatmap_matrix)

# Tracer la heatmap
plt.figure(figsize=(18, len(barcode_labels)*0.5 + 2))
sns.heatmap(matrix, cmap="YlGnBu", xticklabels=500, yticklabels=barcode_labels, cbar_kws={'label': 'Couverture'})
plt.title("Heatmap – Couverture génomique par échantillon (barcode)")
plt.xlabel("Position génomique (1–3200 bp)")
plt.ylabel("Échantillon (barcode)")
plt.tight_layout()

# Sauvegarder le graphique
heatmap_file = os.path.join(output_path, "heatmap_couverture_genome.png")
plt.savefig(heatmap_file, dpi=300)
plt.close()

print(f"✅ Heatmap enregistrée dans : {heatmap_file}")
