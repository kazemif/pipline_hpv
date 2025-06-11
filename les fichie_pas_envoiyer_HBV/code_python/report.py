import os
import zipfile

# === PARAMÈTRES ===
base_path = "./results/graphs"
global_path = os.path.join(base_path, "global")
output_file = os.path.join(global_path, "rapport_global_couverture.html")
zip_path = os.path.join(global_path, "all_graphs.zip")

os.makedirs(global_path, exist_ok=True)

# === 1. CRÉER ARCHIVE ZIP DE TOUS LES PNG ===
with zipfile.ZipFile(zip_path, 'w') as zipf:
    for root, dirs, files in os.walk(base_path):
        for file in files:
            if file.endswith(".png"):
                file_path = os.path.join(root, file)
                arcname = os.path.relpath(file_path, base_path)
                zipf.write(file_path, arcname)

# === 2. GÉNÉRER LE CONTENU HTML ===
html = """
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Rapport global – Couverture et Qualité</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f8f8f8; margin: 40px; }
        h1, h2, h3 { text-align: center; }
        .section { margin-bottom: 60px; }
        .image-container { text-align: center; margin-bottom: 30px; }
        img { max-width: 1000px; width: 90%; border: 1px solid #ccc; background: white; padding: 10px; }
        .subtitle { font-size: 18px; font-weight: bold; margin: 10px; text-align: center; }
    </style>
</head>
<body>
<h1>Rapport global – Couverture génomique & Qualité des données</h1>

<div style="text-align: center; margin-bottom: 40px;">
    <a href="all_graphs.zip" download style="font-size:18px; text-decoration:none; background:#4CAF50; color:white; padding:10px 20px; border-radius:8px;">⬇ Télécharger tous les PNG</a>
</div>
"""

# === Section 1 : Comparaison multi-barcodes ===
multi_barcode_img = "comparaison_couverture_multi_barcodes.png"
if os.path.isfile(os.path.join(global_path, multi_barcode_img)):
    html += f"""
<div class="section">
  <h2>1. Comparaison des barcodes (Modèle 1)</h2>
  <div class="image-container">
    <img src="{multi_barcode_img}" alt="Comparaison multi-barcode">
  </div>
</div>
"""

# === Section 2 : Heatmap de couverture ===
heatmap_img = "heatmap_couverture_genome.png"
if os.path.isfile(os.path.join(global_path, heatmap_img)):
    html += f"""
<div class="section">
  <h2>2. Heatmap de couverture (Modèle 4)</h2>
  <div class="image-container">
    <img src="{heatmap_img}" alt="Heatmap couverture">
  </div>
</div>
"""

# === Section 3 : Area plots (Modèle 2) par barcode ===
html += "<div class='section'><h2>3. Couverture par échantillon (Modèle 2)</h2>"
for subdir in sorted(os.listdir(base_path)):
    subpath = os.path.join(base_path, subdir)
    if os.path.isdir(subpath) and subdir.startswith("barcode"):
        for f in sorted(os.listdir(subpath)):
            if f.endswith("_area_plot.png"):
                html += f"""
  <div class="image-container">
    <div class="subtitle">{subdir}</div>
    <img src="../{subdir}/{f}" alt="{f}">
  </div>
"""
html += "</div>"

# === Section 4 : Graphiques qualité FASTQ ===
html += "<div class='section'><h2>4. Graphiques de qualité FASTQ</h2>"
for f in sorted(os.listdir(global_path)):
    if f.startswith("barplot_") and f.endswith(".png"):
        html += f"""
  <div class="image-container">
    <div class="subtitle">{f.replace("_", " ").replace(".png", "").title()}</div>
    <img src="{f}" alt="{f}">
  </div>
"""
html += "</div>"

# === Fin HTML ===
html += "</body></html>"

# === 3. SAUVEGARDER LE FICHIER HTML ===
with open(output_file, "w", encoding="utf-8") as f:
    f.write(html)

print("✅ Rapport HTML créé :", output_file)
print("✅ Archive ZIP créée :", zip_path)
