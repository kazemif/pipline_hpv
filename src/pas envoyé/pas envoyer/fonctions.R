# ✅ Fichier fonctions.R corrigé pour ton projet

# 📚 CHARGEMENT DES PACKAGES
library(readr)
library(dplyr)
library(ggplot2)
library(stringr)
library(plotly)
library(scales)
library(tidyr)
library(knitr)
library(kableExtra)
library(htmlwidgets)

# 🔹 QUALITÉ DU MAPPING (tout vient de read_alignment_stats/output_barcodeXX)

plot_mapping_gc <- function(base_dir, barcode, output_dir) {
  path <- file.path(base_dir, barcode, "read_alignment_stats", paste0("output_", barcode), paste0(barcode, "_GC_content.txt"))
  message("🔍 Je cherche : ", path)
  if (file.exists(path)) {
    df <- read_csv(path, show_col_types = FALSE)
    colnames(df) <- c("GC_content", "mapped", "occurence")
    df$Type <- ifelse(df$mapped == 1, "Mapped", "Unmapped")
    p <- ggplot(df, aes(x = GC_content, weight = occurence, linetype = Type)) +
      geom_density(color = "blue") +
      labs(title = "GC des reads alignés", x = "GC (%)", y = "Densité") +
      theme_minimal()
    ggsave(file.path(output_dir, paste0(barcode, "_map_gc.pdf")), plot = p)
  } else {
    message("❌ Fichier manquant : ", path)
  }
}

plot_read_mapped_prop <- function(base_dir, barcode, output_dir) {
  path <- file.path(base_dir, barcode, "read_alignment_stats", paste0("output_", barcode), paste0(barcode, "_read_count.txt"))
  message("🔍 ", path)
  if (file.exists(path)) {
    df <- read_delim(path, delim = "\t", skip = 1, col_names = c("Type", "Count"), show_col_types = FALSE)
    df <- df %>% filter(!grepl("total", tolower(Type))) %>%
      mutate(Type = case_when(
        grepl("no mapped", tolower(Type)) ~ "Unmapped",
        grepl("mapped", tolower(Type)) ~ "Mapped",
        TRUE ~ Type
      ))
    total <- sum(df$Count)
    df$Proportion <- df$Count / total * 100
    p <- ggplot(df, aes(x = Type, y = Proportion, fill = Type)) +
      geom_col() +
      labs(title = "% de reads mappés", x = "", y = "Proportion (%)") +
      theme_minimal()
    ggsave(file.path(output_dir, paste0(barcode, "_mapped_prop.pdf")), plot = p)
  } else {
    message("❌ Fichier manquant : ", path)
  }
}

plot_mapped_length <- function(base_dir, barcode, output_dir) {
  path <- file.path(base_dir, barcode, "read_alignment_stats", paste0("output_", barcode), paste0(barcode, "_read_length.txt"))
  message("🔍 ", path)
  if (file.exists(path)) {
    df <- read_csv(path, show_col_types = FALSE)
    colnames(df) <- c("read_length", "mapped", "occurence")
    df$Type <- ifelse(df$mapped == 1, "Mapped", "Unmapped")
    p <- ggplot(df, aes(x = read_length, weight = occurence, linetype = Type)) +
      geom_density(color = "darkred") +
      labs(title = "Longueur des reads alignés", x = "Longueur", y = "Densité") +
      theme_minimal()
    ggsave(file.path(output_dir, paste0(barcode, "_mapped_length.pdf")), plot = p)
  } else {
    message("❌ Fichier manquant : ", path)
  }
}

plot_mapped_seq_score <- function(base_dir, barcode, output_dir) {
  path <- file.path(base_dir, barcode, "read_alignment_stats", paste0("output_", barcode), paste0(barcode, "_seq_score.txt"))
  message("🔍 ", path)
  if (file.exists(path)) {
    df <- read_csv(path, show_col_types = FALSE)
    colnames(df) <- c("seq_score", "mapped", "occurence")
    df$Type <- ifelse(df$mapped == 1, "Mapped", "Unmapped")
    p <- ggplot(df, aes(x = seq_score, weight = occurence, linetype = Type)) +
      geom_density(color = "darkorange") +
      labs(title = "Score des reads alignés", x = "Score", y = "Densité") +
      theme_minimal()
    ggsave(file.path(output_dir, paste0(barcode, "_mapped_score.pdf")), plot = p)
  } else {
    message("❌ Fichier manquant : ", path)
  }
}

plot_mapping_score <- function(base_dir, barcode, output_dir) {
  path <- file.path(base_dir, barcode, "read_alignment_stats", paste0("output_", barcode), paste0(barcode, "_map_score.txt"))
  message("🔍 ", path)
  if (file.exists(path)) {
    df <- read_csv(path, show_col_types = FALSE)
    colnames(df) <- c("map_score", "mapped", "occurence")
    p <- ggplot(df, aes(x = map_score, weight = occurence)) +
      geom_density(color = "darkblue") +
      labs(title = "Score de mapping", x = "Score", y = "Densité") +
      theme_minimal()
    ggsave(file.path(output_dir, paste0(barcode, "_map_score.pdf")), plot = p)
  } else {
    message("❌ Fichier manquant : ", path)
  }
}