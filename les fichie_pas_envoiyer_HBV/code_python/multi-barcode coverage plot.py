import os
import pandas as pd
import matplotlib.pyplot as plt

# Paramètres
base_path = "./results"
genome_max_pos = 3200
window_size = 100
output_dir = os.path.join(base_path, "graphs", "global")
os.makedirs(output_dir, exist_ok=True)  # crée le dossier s'il n'existe pas

plt.figure(figsize=(16, 6))

# Traiter tous les barcodes
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

        # Vecteur de couverture base à base
        coverage_vector = [0] * genome_max_pos
        for _, row in df.iterrows():
            for i in range(row["start"], min(row["end"], genome_max_pos)):
                coverage_vector[i - 1] = row["coverage"]

        # Lissage (moyenne glissante)
        smoothed = pd.Series(coverage_vector).rolling(window=window_size, min_periods=1).mean()

        # Tracer
        plt.plot(range(1, genome_max_pos + 1), smoothed, label=subdir)

# Ligne de seuil
plt.axhline(y=10, color='red', linestyle='--', label='Seuil faible couverture (10)')
plt.title("Comparaison des couvertures génomiques par barcode")
plt.xlabel("Position génomique (bp)")
plt.ylabel("Couverture lissée")
plt.legend(loc="upper right", fontsize="small", ncol=2)
plt.tight_layout()

# Sauvegarde (pas de show)
output_path = os.path.join(output_dir, "comparaison_couverture_multi_barcodes.png")
plt.savefig(output_path)
plt.close()
print(f"✅ Graphe multi-barcodes sauvegardé dans : {output_path}")
