import os
import glob
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Style seaborn
sns.set(style="whitegrid")

# Chercher tous les fichiers per_read_stats.tsv
fichiers = glob.glob("results/barcode*/**/per_read_stats.tsv", recursive=True)

# Lire chaque fichier
for chemin in fichiers:
    try:
        df = pd.read_csv(chemin, sep='\t')
        barcode = chemin.split("/")[1]  # Extrait barcode01, barcode02, ...

        # Créer dossier pour les graphiques de ce barcode
        output_dir = f"results/graphs/{barcode}"
        os.makedirs(output_dir, exist_ok=True)

        # Graphique 1 : Read Length
        plt.figure(figsize=(6, 4))
        sns.histplot(df["Length"], bins=30)
        plt.title("Longueur des lectures")
        plt.xlabel("Length")
        plt.ylabel("Reads")
        plt.tight_layout()
        plt.savefig(f"{output_dir}/barplot_read_length.png")
        plt.close()

        # Graphique 2 : GC content
        plt.figure(figsize=(6, 4))
        sns.histplot(df["GC_content"], bins=30, color='green')
        plt.title("Contenu en GC")
        plt.xlabel("GC %")
        plt.ylabel("Reads")
        plt.tight_layout()
        plt.savefig(f"{output_dir}/barplot_gc_content.png")
        plt.close()

        # Graphique 3 : Avg Quality
        plt.figure(figsize=(6, 4))
        sns.histplot(df["Avg_Quality"], bins=30, color='orange')
        plt.title("Qualité moyenne de séquençage")
        plt.xlabel("Score qualité")
        plt.ylabel("Reads")
        plt.tight_layout()
        plt.savefig(f"{output_dir}/barplot_avg_quality.png")
        plt.close()

        # Graphique 4 : Mapping Quality
        plt.figure(figsize=(6, 4))
        sns.histplot(df["Mapping_Quality"], bins=30, color='purple')
        plt.title("Mapping Quality")
        plt.xlabel("Score de mapping")
        plt.ylabel("Reads")
        plt.tight_layout()
        plt.savefig(f"{output_dir}/barplot_mapping_quality.png")
        plt.close()

        # Graphique 5 : Mapped vs Unmapped
        fichier_map = f"results/{barcode}/read_alignment_stats/{barcode}_mapped_unmapped.txt"
        if os.path.exists(fichier_map):
            with open(fichier_map, "r") as f:
                lignes = f.readlines()
                mapped = int(lignes[0].split(":")[1].strip())
                unmapped = int(lignes[1].split(":")[1].strip())

            df_map = pd.DataFrame({
                "Status": ["Mapped", "Unmapped"],
                "Count": [mapped, unmapped]
            })

            plt.figure(figsize=(5, 4))
            sns.barplot(data=df_map, x="Status", y="Count", palette="pastel")
            plt.title("Mapped vs Unmapped")
            plt.tight_layout()
            plt.savefig(f"{output_dir}/barplot_mapped_vs_unmapped.png")
            plt.close()

        print(f"✅ Graphiques enregistrés pour {barcode}")

    except Exception as e:
        print(f"⚠️ Erreur avec {chemin} : {e}")



