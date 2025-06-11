import os  
import glob
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import base64

sns.set(style="whitegrid")

# 📁 Chemins
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

# 📈 Fonctions
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

def encode_image_base64(image_path):
    with open(image_path, "rb") as img_file:
        return base64.b64encode(img_file.read()).decode('utf-8')

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

fig9_path = os.path.join(graphs_dir, "fig9_mapped_txt_barplot.png")
df_map_txt[["Mapped %", "Unmapped %"]].plot(kind="barh", stacked=True, color=["limegreen", "salmon"], figsize=(8, 5))
plt.title("9. Proportion reads (fichier TXT)")
plt.xlabel("Proportion (%)")
plt.tight_layout()
plt.savefig(fig9_path)
plt.close()

# 📊 Génération des 8 autres figures
fig1 = plot_density(df_all, "GC_content", "1. Composition en GC", "GC (%)", "fig1_gc_content.png")
fig2 = plot_density(df_all, "Length", "2. Longueur des reads", "Longueur (bp)", "fig2_read_length.png")
fig3 = plot_density(df_all, "Avg_Quality", "3. Score qualité de séquençage", "Score qualité (Phred)", "fig3_avg_quality.png")
fig4 = plot_density(df_all, "Mapping_Quality", "4. Score qualité mapping", "Mapping Quality (Phred)", "fig4_mapping_quality.png")
fig5 = plot_mapped_bar(df_all, "fig5_mapped_barplot.png")
fig6 = plot_density(df_all, "GC_content", "6. GC Mapped vs Unmapped", "GC (%)", "fig6_gc_mapped_unmapped.png", hue="Mapped")
fig7 = plot_density(df_all, "Length", "7. Longueur Mapped vs Unmapped", "Longueur (bp)", "fig7_len_mapped_unmapped.png", hue="Mapped")
fig8 = plot_density(df_all, "Avg_Quality", "8. Qualité Mapped vs Unmapped", "Score qualité", "fig8_qual_mapped_unmapped.png", hue="Mapped")

# 🔄 Encodage Base64
figs_b64 = {
    "fig1": encode_image_base64(fig1),
    "fig2": encode_image_base64(fig2),
    "fig3": encode_image_base64(fig3),
    "fig4": encode_image_base64(fig4),
    "fig5": encode_image_base64(fig5),
    "fig6": encode_image_base64(fig6),
    "fig7": encode_image_base64(fig7),
    "fig8": encode_image_base64(fig8),
    "fig9": encode_image_base64(fig9_path)
}

# 📝 HTML rapport final
html = f"""
<html>
<head><meta charset='UTF-8'><title>Rapport Séquençage HBV</title></head>
<body style="font-family:sans-serif; padding:20px;">
<h1 style="color:#2E8B57;">Rapport Global – Analyse de Séquençage Hépatite B</h1>

<h2>Qualité du séquençage</h2>
<h3>1. Composition en GC</h3><div style='text-align:center'><img src="data:image/png;base64,{figs_b64['fig1']}" width="700"></div><br>
<h3>2. Longueur des reads</h3><div style='text-align:center'><img src="data:image/png;base64,{figs_b64['fig2']}" width="700"></div><br>
<h3>3. Score qualité de séquençage</h3><div style='text-align:center'><img src="data:image/png;base64,{figs_b64['fig3']}" width="700"></div><br>
<h3>4. Score qualité du mapping</h3><div style='text-align:center'><img src="data:image/png;base64,{figs_b64['fig4']}" width="700"></div><br>

<h2>Qualité du mapping</h2>
<h3>5. Proportion mapped / unmapped (calculé)</h3><div style='text-align:center'><img src="data:image/png;base64,{figs_b64['fig5']}" width="700"></div><br>
<h3>6. GC mapped vs unmapped</h3><div style='text-align:center'><img src="data:image/png;base64,{figs_b64['fig6']}" width="700"></div><br>
<h3>7. Longueur mapped vs unmapped</h3><div style='text-align:center'><img src="data:image/png;base64,{figs_b64['fig7']}" width="700"></div><br>
<h3>8. Qualité mapped vs unmapped</h3><div style='text-align:center'><img src="data:image/png;base64,{figs_b64['fig8']}" width="700"></div><br>
<h3>9. Proportion mapped / unmapped (fichier TXT)</h3><div style='text-align:center'><img src="data:image/png;base64,{figs_b64['fig9']}" width="700"></div><br>

<footer style="margin-top:50px; color:gray;">
<p>Rapport généré automatiquement – Pipeline HBV – Fatemeh Kazemi</p>
</footer>
</body>
</html>
"""

with open(output_html, "w", encoding="utf-8") as f:
    f.write(html)

print(f"✅ Rapport HTML autonome généré avec succès : {output_html}")

