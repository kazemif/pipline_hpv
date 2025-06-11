# 📦 Chargement
library(readr)
library(dplyr)
library(ggplot2)
library(stringr)
library(scales)

# 📥 Charger les fonctions
source("scripts_r/fonctions_globales.R")

# 📁 Dossiers
base_dir <- "src/results"
output_dir <- "scripts_r/figures"
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# 📋 Liste des fonctions et noms de fichiers
analyses <- list(
  list(f = plot_gc_all,              file = "01_gc_global.pdf"),
  list(f = plot_read_length_all,     file = "02_read_length_global.pdf"),
  list(f = plot_seq_score_all,       file = "03_seq_score_global.pdf")
  # ⚠️ tu ajouteras ici les autres fonctions : plot_mapping_score_all, etc.
)

# 🔁 Boucle pour lancer chaque fonction une seule fois
for (analyse in analyses) {
  analyse$f(base_dir, file.path(output_dir, analyse$file))
}
