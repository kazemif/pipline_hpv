generate_all_qc_plots <- function(base_dir, barcodes) {
  # 📦 Packages nécessaires
  library(readr)
  library(dplyr)
  library(ggplot2)
  library(stringr)
  ##library(tidyr)
  library(plotly)

  plots <- list()

  # 1. Composition en GC (raw)
  plots$gc_raw <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "qc_fastq", paste0("output_", bc), paste0(bc, "_GC_content.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      df$barcode <- bc
      df
    }) %>% bind_rows()
    p <- ggplot(df_all, aes(x = GC_content, color = barcode, group = barcode)) +
      geom_density(size = 0.5) +
      labs(title = "1. Composition en GC (raw)", x = "GC (%)", y = "Densité") +
      scale_x_continuous(breaks = seq(0, 100, 10), limits = c(0, 100)) +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }

  # 2. Longueur des reads (raw)
  plots$length_raw <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "qc_fastq", paste0("output_", bc), paste0(bc, "_read_length.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      colnames(df) <- "read_length"
      df$barcode <- bc
      df
    }) %>% bind_rows()
    p <- ggplot(df_all, aes(x = read_length, color = barcode, group = barcode)) +
      geom_density(size = 0.5) +
      labs(title = "2. Longueur des reads (raw)", x = "Longueur (bases)", y = "Densité") +
      scale_x_continuous(breaks = seq(100, 1200, 100), limits = c(100, 1200)) +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }

  # 3. Score qualité (Phred) raw
  plots$phred_raw <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "qc_fastq", paste0("output_", bc), paste0(bc, "_seq_score.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      colnames(df) <- "seq_score"
      df$barcode <- bc
      df
    }) %>% bind_rows()
    p <- ggplot(df_all, aes(x = seq_score, color = barcode, group = barcode)) +
      geom_density(size = 0.5) +
      labs(title = "3. Score qualité (Phred) raw", x = "Score", y = "Densité") +
      scale_x_continuous(breaks = seq(10, 80, 10), limits = c(10, 80)) +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }

  # 4. Score Phred par position (raw)
  plots$phred_by_pos_raw <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "qc_fastq", paste0("output_", bc), paste0(bc, "_per_base_seq_score.txt"))
      if (!file.exists(path)) return(NULL)
      mat <- as.matrix(read.table(path, header = FALSE))
      med <- apply(mat, 2, median, na.rm = TRUE)
      data.frame(position = seq_along(med), score = med, barcode = bc)
    }) %>% bind_rows()
    p <- ggplot(df_all, aes(x = position, y = score, color = barcode)) +
      geom_line(size = 0.7) +
      labs(title = "4. Score Phred par position (raw)", x = "Position", y = "Score qualité") +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }

  # 5. Composition GC des reads alignés
  plots$gc_mapped <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "read_alignment_stats", paste0("output_", bc), paste0(bc, "_GC_content.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      colnames(df) <- c("GC_content","mapped","occurence")
      df$barcode <- bc
      df
    }) %>% bind_rows()
    df_m <- df_all %>% mutate(Type = ifelse(mapped == 1, "Mapped", "Unmapped"))
    p <- ggplot(df_m, aes(x = GC_content, weight = occurence, color = barcode, linetype = Type)) +
      geom_density(size = 1) +
      labs(title = "5. Composition GC des reads alignés", x = "GC (%)", y = "Densité") +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }

  # 6. Proportion reads mappés vs unmappés
  plots$reads_mapped_prop <- {
    rs <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "read_alignment_stats", paste0("output_", bc), paste0(bc, "_read_count.txt"))
      if (!file.exists(path)) return(NULL)
      lines <- readLines(path)
      if (length(lines) < 2) return(NULL)
      lines <- lines[-1]
      lines <- lines[lines != "" & !grepl("^total", lines, ignore.case = TRUE)]
      mat <- stringr::str_match(lines, "^(.*)\\s+(\\d+)$")
      df <- data.frame(
        read = mat[,2],
        occurence = as.numeric(mat[,3]),
        stringsAsFactors = FALSE
      )
      df %>% mutate(
        Type = ifelse(grepl("no mapped", tolower(read)), "Unmapped", "Mapped"),
        Count = occurence,
        barcode = bc
      )
    }) %>% bind_rows()
    df_s <- rs %>% group_by(barcode) %>% mutate(Proportion = Count / sum(Count) * 100) %>% ungroup()
    p <- ggplot(df_s, aes(x = barcode, y = Proportion, fill = Type)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "6. % reads mappés vs unmappés", y = "Proportion (%)") +
      theme_minimal()
    ggplotly(p, tooltip = "text")
  }

  # 7. Longueur reads mappés vs unmappés
  plots$length_mapped <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "read_alignment_stats", paste0("output_", bc), paste0(bc, "_read_length.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      colnames(df) <- c("length","mapped","occurence")
      df <- df %>% filter(occurence > 0)
      df$Type <- ifelse(df$mapped == 1, "Mapped", "Unmapped")
      df$barcode <- bc
      df
    }) %>% bind_rows()
    p <- ggplot(df_all, aes(x = length, weight = occurence, color = barcode, linetype = Type)) +
      geom_density(size = 1) +
      labs(title = "7. Longueur reads mappés vs unmappés", x = "Longueur", y = "Densité") +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }

  # 8. Distribution du score de mapping
  plots$map_score <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "read_alignment_stats", paste0("output_", bc), paste0(bc, "_map_score.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      colnames(df) <- c("map_score","mapped","occurence")
      df <- df %>% filter(mapped == 1 & occurence > 0)
      df$barcode <- bc
      df
    }) %>% bind_rows()
    p <- ggplot(df_all, aes(x = map_score, weight = occurence, color = barcode)) +
      geom_density(size = 0.6) +
      labs(title = "8. Score qualité du mapping", x = "Map Score", y = "Densité") +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }

  # 9. Score Phred des reads mappés
  plots$phred_mapped <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "read_alignment_stats", paste0("output_", bc), paste0(bc, "_seq_score.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      colnames(df) <- c("seq_score","mapped","occurence")
      df <- df %>% filter(mapped == 1 & occurence > 0)
      df$barcode <- bc
      df
    }) %>% bind_rows()
    p <- ggplot(df_all, aes(x = seq_score, weight = occurence, color = barcode)) +
      geom_density(size = 0.6) +
      labs(title = "9. Score Phred des reads mappés", x = "Phred Score", y = "Densité") +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }

  # 10. Heatmap couverture/profondeur
  plots$coverage_heatmap <- {
  # → on réutilise df_all et df calculés comme avant
  df_all <- lapply(barcodes, function(bc) {
    path <- file.path(base_dir, bc, "coverage", paste0(bc, ".coverage.bed"))
    if (!file.exists(path)) return(NULL)
    df <- readr::read_tsv(path, col_names=FALSE, show_col_types=FALSE)
    names(df) <- c("Chr","Pos","Depth")
    df$Sample <- bc
    df
  }) %>% dplyr::bind_rows()

  df <- df_all %>%
    dplyr::mutate(
      Class = dplyr::case_when(
        Depth < 20 ~ "<20X",
        Depth < 30 ~ "20-30X",
        Depth < 50 ~ "30-50X",
        TRUE       ~ "≥50X"
      )
    ) %>%
    dplyr::mutate(
      Class = factor(Class, levels=c("<20X","20-30X","30-50X","≥50X"))
    )
  
  # **Ne PAS** faire ggplotly() ici, juste un statique ggplot :
  ggplot2::ggplot(df, aes(x=Pos, y=Sample, fill=Class)) +
    ggplot2::geom_tile() +
    ggplot2::scale_fill_manual(values=c(
      "<20X"    = "#e74c3c",
      "20-30X"  = "#e67e22",
      "30-50X"  = "#3498db",
      "≥50X"    = "#2ecc71"
    )) +
    ggplot2::labs(
      title="10. Heatmap couverture/profondeur",
      x="Position",
      y="Échantillon",
      fill="Profondeur"
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.text.x = element_text(angle=45, hjust=1),
      plot.title  = element_text(face="bold")
    )
}


  # 11. Tableau de pourcentage de couverture
  plots$coverage_summary <- {
    results <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "coverage", paste0(bc, ".coverage.bed"))
      if (!file.exists(path)) return(NULL)
      df <- read_tsv(path, col_names = FALSE, show_col_types = FALSE)
      names(df) <- c("Chr","Pos","Depth")
      pct <- sum(df$Depth >= 1) / max(df$Pos, na.rm = TRUE) * 100
      data.frame(barcode = bc, Coverage = round(pct, 1))
    }) %>% bind_rows()
    results %>% arrange(desc(Coverage))
  }

  return(plots)
}












///////////////************mohem 

process generateReport {
    tag "📝 rapport"
    publishDir "${params.result_dir}/reports", mode: 'copy'

    output:
      path 'rapport_final.html'

    script:
    """
    # 1) Aller à la racine du projet (au-dessus de src/)
    cd ${workflow.projectDir}/..

    # 2) Créer le dossier de sortie
    mkdir -p results/reports

    # 3) Rendre le RMarkdown (une seule ligne !)
    Rscript -e "rmarkdown::render('src/rapport_final.Rmd', output_dir='results/reports')"

    # 4) Copier le HTML pour Nextflow
    cp results/reports/rapport_final.html .
    """
}

/////////////////////************rmarkdown


---
title: "Rapport QC & Mapping HBV"
output: html_document
---

```{r setup, include=FALSE}
library(ggplot2); library(dplyr); library(readr); library(stringr); library(plotly)
# on est dans hbv_pipeline (projectDir)/..
source("src/scripts_r/fonctions_globales.R")

# <-- Ici on pointe sur results/ à la racine du projet :
base_dir <- "src/results"

barcodes <- sprintf("barcode%02d", 1:16)
plots <- generate_all_qc_plots(base_dir, barcodes)

```{r setup, include=FALSE}
library(ggplot2)
library(dplyr)
library(readr)
library(stringr)
library(plotly)
library(here) 

source("scripts_r/fonctions_globales.R")

# ici on prend bien results/, pas src/results
base_dir <- "results"

##base_dir <- "src/results"
barcodes <- sprintf("barcode%02d", 1:16)
plots <- generate_all_qc_plots(base_dir, barcodes)

**********************************
////////////generate_all_qc_plots <- function(base_dir, barcodes) {
  # 📦 Packages nécessaires
  library(readr)
  library(dplyr)
  library(ggplot2)
  library(stringr)
  library(tidyr)
  library(plotly)

  plots <- list()

  # 1. Composition en GC (raw)
  plots$gc_raw <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "qc_fastq", paste0("output_", bc), paste0(bc, "_GC_content.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      df$barcode <- bc
      df
    }) %>% bind_rows()
    p <- ggplot(df_all, aes(x = GC_content, color = barcode, group = barcode)) +
      geom_density(size = 0.5) +
      labs(title = "1. Composition en GC (raw)", x = "GC (%)", y = "Densité") +
      scale_x_continuous(breaks = seq(0, 100, 10), limits = c(0, 100)) +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }

  # 2. Longueur des reads (raw)
  plots$length_raw <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "qc_fastq", paste0("output_", bc), paste0(bc, "_read_length.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      colnames(df) <- "read_length"
      df$barcode <- bc
      df
    }) %>% bind_rows()
    p <- ggplot(df_all, aes(x = read_length, color = barcode, group = barcode)) +
      geom_density(size = 0.5) +
      labs(title = "2. Longueur des reads (raw)", x = "Longueur (bases)", y = "Densité") +
      scale_x_continuous(breaks = seq(100, 1200, 100), limits = c(100, 1200)) +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }

  # 3. Score qualité (Phred) raw
  plots$phred_raw <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "qc_fastq", paste0("output_", bc), paste0(bc, "_seq_score.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      colnames(df) <- "seq_score"
      df$barcode <- bc
      df
    }) %>% bind_rows()
    p <- ggplot(df_all, aes(x = seq_score, color = barcode, group = barcode)) +
      geom_density(size = 0.5) +
      labs(title = "3. Score qualité (Phred) raw", x = "Score", y = "Densité") +
      scale_x_continuous(breaks = seq(10, 80, 10), limits = c(10, 80)) +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }

  # 4. Score Phred par position (raw)
  plots$phred_by_pos_raw <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "qc_fastq", paste0("output_", bc), paste0(bc, "_per_base_seq_score.txt"))
      if (!file.exists(path)) return(NULL)
      mat <- as.matrix(read.table(path, header = FALSE))
      med <- apply(mat, 2, median, na.rm = TRUE)
      data.frame(position = seq_along(med), score = med, barcode = bc)
    }) %>% bind_rows()
    p <- ggplot(df_all, aes(x = position, y = score, color = barcode)) +
      geom_line(size = 0.7) +
      labs(title = "4. Score Phred par position (raw)", x = "Position", y = "Score qualité") +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }

  # 5. Composition GC des reads alignés
  plots$gc_mapped <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "read_alignment_stats", paste0("output_", bc), paste0(bc, "_GC_content.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      colnames(df) <- c("GC_content","mapped","occurence")
      df$barcode <- bc
      df
    }) %>% bind_rows()
    df_m <- df_all %>% mutate(Type = ifelse(mapped == 1, "Mapped", "Unmapped"))
    p <- ggplot(df_m, aes(x = GC_content, weight = occurence, color = barcode, linetype = Type)) +
      geom_density(size = 1) +
      labs(title = "5. Composition GC des reads alignés", x = "GC (%)", y = "Densité") +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }

  # 6. Proportion reads mappés vs unmappés
  plots$reads_mapped_prop <- {
    rs <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "read_alignment_stats", paste0("output_", bc), paste0(bc, "_read_count.txt"))
      if (!file.exists(path)) return(NULL)
      lines <- readLines(path)
      if (length(lines) < 2) return(NULL)
      lines <- lines[-1]
      lines <- lines[lines != "" & !grepl("^total", lines, ignore.case = TRUE)]
      mat <- stringr::str_match(lines, "^(.*)\\s+(\\d+)$")
      df <- data.frame(
        read = mat[,2],
        occurence = as.numeric(mat[,3]),
        stringsAsFactors = FALSE
      )
      df %>% mutate(
        Type = ifelse(grepl("no mapped", tolower(read)), "Unmapped", "Mapped"),
        Count = occurence,
        barcode = bc
      )
    }) %>% bind_rows()
    df_s <- rs %>% group_by(barcode) %>% mutate(Proportion = Count / sum(Count) * 100) %>% ungroup()
    p <- ggplot(df_s, aes(x = barcode, y = Proportion, fill = Type)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "6. % reads mappés vs unmappés", y = "Proportion (%)") +
      theme_minimal()
    ggplotly(p, tooltip = "text")
  }

  # 7. Longueur reads mappés vs unmappés
  plots$length_mapped <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "read_alignment_stats", paste0("output_", bc), paste0(bc, "_read_length.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      colnames(df) <- c("length","mapped","occurence")
      df <- df %>% filter(occurence > 0)
      df$Type <- ifelse(df$mapped == 1, "Mapped", "Unmapped")
      df$barcode <- bc
      df
    }) %>% bind_rows()
    p <- ggplot(df_all, aes(x = length, weight = occurence, color = barcode, linetype = Type)) +
      geom_density(size = 1) +
      labs(title = "7. Longueur reads mappés vs unmappés", x = "Longueur", y = "Densité") +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }

  # 8. Distribution du score de mapping
  plots$map_score <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "read_alignment_stats", paste0("output_", bc), paste0(bc, "_map_score.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      colnames(df) <- c("map_score","mapped","occurence")
      df <- df %>% filter(mapped == 1 & occurence > 0)
      df$barcode <- bc
      df
    }) %>% bind_rows()
    p <- ggplot(df_all, aes(x = map_score, weight = occurence, color = barcode)) +
      geom_density(size = 0.6) +
      labs(title = "8. Score qualité du mapping", x = "Map Score", y = "Densité") +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }

  # 9. Score Phred des reads mappés
  plots$phred_mapped <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "read_alignment_stats", paste0("output_", bc), paste0(bc, "_seq_score.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      colnames(df) <- c("seq_score","mapped","occurence")
      df <- df %>% filter(mapped == 1 & occurence > 0)
      df$barcode <- bc
      df
    }) %>% bind_rows()
    p <- ggplot(df_all, aes(x = seq_score, weight = occurence, color = barcode)) +
      geom_density(size = 0.6) +
      labs(title = "9. Score Phred des reads mappés", x = "Phred Score", y = "Densité") +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }

  # 10. Heatmap couverture/profondeur
  plots$coverage_heatmap <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "coverage", paste0(bc, ".coverage.bed"))
      if (!file.exists(path)) return(NULL)
      df <- read_tsv(path, col_names = FALSE, show_col_types = FALSE)
      names(df) <- c("Chr","Pos","Depth")
      df$Sample <- bc
      df
    }) %>% bind_rows()
    df <- df_all %>% mutate(
      Class = case_when(
        Depth < 20             ~ "<20X",
        Depth < 30             ~ "20-30X",
        Depth < 50             ~ "30-50X",
        TRUE                    ~ "≥50X"
      )
    )
    df$Class <- factor(df$Class, levels = c("<20X","20-30X","30-50X","≥50X"))
    p <- ggplot(df, aes(x = Pos, y = Sample, fill = Class)) +
      geom_tile() +
      labs(title = "10. Heatmap couverture/profondeur", x = "Position", y = "Échantillon") +
      theme_minimal()
    ggplotly(p, tooltip = "fill")
  }

  # 11. Tableau de pourcentage de couverture
  plots$coverage_summary <- {
    results <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "coverage", paste0(bc, ".coverage.bed"))
      if (!file.exists(path)) return(NULL)
      df <- read_tsv(path, col_names = FALSE, show_col_types = FALSE)
      names(df) <- c("Chr","Pos","Depth")
      pct <- sum(df$Depth >= 1) / max(df$Pos, na.rm = TRUE) * 100
      data.frame(barcode = bc, Coverage = round(pct, 1))
    }) %>% bind_rows()
    results %>% arrange(desc(Coverage))
  }

  return(plots)
}


//////////////////////******************************
rapport_final.Rmd
markdown
Copier
Modifier
---
title: "Rapport QC & Mapping HBV"
output: html_document
---

```{r setup, include=FALSE}
library(ggplot2)
library(dplyr)
library(readr)
library(stringr)
library(tidyr)
library(plotly)
source("scripts_r/fonctions_globales.R")

base_dir <- "src/results"
barcodes <- sprintf("barcode%02d", 1:16)
plots <- generate_all_qc_plots(base_dir, barcodes)



Copie ces deux fichiers, puis dans ton terminal (depuis le dossier hbv_pipeline) :

bash
Copier
Modifier


Rscript -e "rmarkdown::render('rapport_final.Rmd', output_dir='results/reports')"









////////////////////////////#################################03/06

generate_all_qc_plots <- function(base_dir, barcodes) {
  library(readr)
  library(dplyr)
  library(ggplot2)
  library(stringr)
  library(plotly)

  plots <- list()

  # 1. Composition en GC (raw)
  plots$gc_raw <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "qc_fastq", paste0("output_", bc), paste0(bc, "_GC_content.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_delim(path, delim = ",", show_col_types = FALSE)
      df$barcode <- bc
      df
    }) %>% bind_rows()
    if (nrow(df_all) == 0) return(NULL)
    p <- ggplot(df_all, aes(x = GC_content, color = barcode, group = barcode)) +
      geom_density(size = 0.5) +
      labs(title = "1. Composition en GC (raw)", x = "GC (%)", y = "Densité") +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }

  # 2. Longueur des reads (raw)
  plots$length_raw <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "qc_fastq", paste0("output_", bc), paste0(bc, "_read_length.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_delim(path, delim = ",", show_col_types = FALSE)
      colnames(df) <- "read_length"
      df$barcode <- bc
      df
    }) %>% bind_rows()
    if (nrow(df_all) == 0) return(NULL)
    p <- ggplot(df_all, aes(x = read_length, color = barcode, group = barcode)) +
      geom_density(size = 0.5) +
      labs(title = "2. Longueur des reads (raw)", x = "Longueur", y = "Densité") +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }

  # 3. Score qualité (Phred) raw
  plots$phred_raw <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "qc_fastq", paste0("output_", bc), paste0(bc, "_seq_score.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_delim(path, delim = ",", show_col_types = FALSE)
      colnames(df) <- "seq_score"
      df$barcode <- bc
      df
    }) %>% bind_rows()
    if (nrow(df_all) == 0) return(NULL)
    p <- ggplot(df_all, aes(x = seq_score, color = barcode, group = barcode)) +
      geom_density(size = 0.5) +
      labs(title = "3. Score qualité (Phred) raw", x = "Score", y = "Densité") +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }

  # 4. Score Phred par position (raw)
  plots$phred_by_pos_raw <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "qc_fastq", paste0("output_", bc), paste0(bc, "_per_base_seq_score.txt"))
      if (!file.exists(path)) return(NULL)
      mat <- as.matrix(read.table(path, header = FALSE))
      med <- apply(mat, 2, median, na.rm = TRUE)
      data.frame(position = seq_along(med), score = med, barcode = bc)
    }) %>% bind_rows()
    if (nrow(df_all) == 0) return(NULL)
    p <- ggplot(df_all, aes(x = position, y = score, color = barcode)) +
      geom_line(size = 0.7) +
      labs(title = "4. Score Phred par position (raw)", x = "Position", y = "Score qualité") +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }

  # 5. Composition GC des reads alignés
  plots$gc_mapped <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "read_alignment_stats", paste0("output_", bc), paste0(bc, "_GC_content.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_delim(path, delim = ",", show_col_types = FALSE)
      colnames(df) <- c("GC_content", "mapped", "occurence")
      df$barcode <- bc
      df
    }) %>% bind_rows()
    if (nrow(df_all) == 0) return(NULL)
    df_m <- df_all %>% mutate(Type = ifelse(mapped == 1, "Mapped", "Unmapped"))
    p <- ggplot(df_m, aes(x = GC_content, weight = occurence, color = barcode, linetype = Type)) +
      geom_density(size = 1) +
      labs(title = "5. Composition GC des reads alignés", x = "GC (%)", y = "Densité") +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }

  # 6. Proportion reads mappés vs unmappés
  plots$reads_mapped_prop <- {
    rs <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "read_alignment_stats", paste0("output_", bc), paste0(bc, "_read_count.txt"))
      if (!file.exists(path)) return(NULL)
      lines <- readLines(path)
      lines <- lines[-1]
      lines <- lines[lines != "" & !grepl("^total", lines, ignore.case = TRUE)]
      mat <- stringr::str_match(lines, "^(.*)\\s+(\\d+)$")
      df <- data.frame(read = mat[,2], occurence = as.numeric(mat[,3]), stringsAsFactors = FALSE)
      df %>% mutate(
        Type = ifelse(grepl("no mapped", tolower(read)), "Unmapped", "Mapped"),
        Count = occurence,
        barcode = bc
      )
    }) %>% bind_rows()
    if (nrow(rs) == 0) return(NULL)
    df_s <- rs %>% group_by(barcode) %>% mutate(Proportion = Count / sum(Count) * 100) %>% ungroup()
    p <- ggplot(df_s, aes(x = barcode, y = Proportion, fill = Type)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "6. % reads mappés vs unmappés", y = "Proportion (%)") +
      theme_minimal()
    ggplotly(p, tooltip = "text")
  }

  # 7. Longueur reads mappés vs unmappés
  plots$length_mapped <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "read_alignment_stats", paste0("output_", bc), paste0(bc, "_read_length.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_delim(path, delim = ",", show_col_types = FALSE)
      colnames(df) <- c("length", "mapped", "occurence")
      df <- df %>% filter(occurence > 0)
      df$Type <- ifelse(df$mapped == 1, "Mapped", "Unmapped")
      df$barcode <- bc
      df
    }) %>% bind_rows()
    if (nrow(df_all) == 0) return(NULL)
    p <- ggplot(df_all, aes(x = length, weight = occurence, color = barcode, linetype = Type)) +
      geom_density(size = 1) +
      labs(title = "7. Longueur reads mappés vs unmappés", x = "Longueur", y = "Densité") +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }

  # 8. Score de mapping
  plots$map_score <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "read_alignment_stats", paste0("output_", bc), paste0(bc, "_map_score.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_delim(path, delim = ",", show_col_types = FALSE)
      colnames(df) <- c("map_score", "mapped", "occurence")
      df <- df %>% filter(mapped == 1 & occurence > 0)
      df$barcode <- bc
      df
    }) %>% bind_rows()
    if (nrow(df_all) == 0) return(NULL)
    p <- ggplot(df_all, aes(x = map_score, weight = occurence, color = barcode)) +
      geom_density(size = 0.6) +
      labs(title = "8. Score qualité du mapping", x = "Map Score", y = "Densité") +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }

  # 9. Score Phred des reads mappés
  plots$phred_mapped <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "read_alignment_stats", paste0("output_", bc), paste0(bc, "_seq_score.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_delim(path, delim = ",", show_col_types = FALSE)
      colnames(df) <- c("seq_score", "mapped", "occurence")
      df <- df %>% filter(mapped == 1 & occurence > 0)
      df$barcode <- bc
      df
    }) %>% bind_rows()
    if (nrow(df_all) == 0) return(NULL)
    p <- ggplot(df_all, aes(x = seq_score, weight = occurence, color = barcode)) +
      geom_density(size = 0.6) +
      labs(title = "9. Score Phred des reads mappés", x = "Phred Score", y = "Densité") +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }

  # 10. Heatmap couverture/profondeur (non-interactive)
  plots$coverage_heatmap <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "coverage", paste0(bc, ".coverage.bed"))
      if (!file.exists(path)) return(NULL)
      df <- read_tsv(path, col_names = FALSE, show_col_types = FALSE)
      names(df) <- c("Chr", "Pos", "Depth")
      df$Sample <- bc
      df
    }) %>% bind_rows()
    if (nrow(df_all) == 0) return(NULL)
    df <- df_all %>%
      mutate(Class = case_when(
        Depth < 20 ~ "<20X",
        Depth < 30 ~ "20-30X",
        Depth < 50 ~ "30-50X",
        TRUE ~ "≥50X"
      )) %>%
      mutate(Class = factor(Class, levels = c("<20X", "20-30X", "30-50X", "≥50X")))

    ggplot(df, aes(x = Pos, y = Sample, fill = Class)) +
      geom_tile() +
      scale_fill_manual(values = c("<20X" = "#e74c3c", "20-30X" = "#e67e22", "30-50X" = "#3498db", "≥50X" = "#2ecc71")) +
      labs(title = "10. Heatmap couverture/profondeur", x = "Position", y = "Échantillon", fill = "Profondeur") +
      theme_minimal()
  }

  # 11. Pourcentage de couverture
  plots$coverage_summary <- {
    results <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "coverage", paste0(bc, ".coverage.bed"))
      if (!file.exists(path)) return(NULL)
      df <- read_tsv(path, col_names = FALSE, show_col_types = FALSE)
      names(df) <- c("Chr", "Pos", "Depth")
      pct <- sum(df$Depth >= 1) / max(df$Pos, na.rm = TRUE) * 100
      data.frame(barcode = bc, Coverage = round(pct, 1))
    }) %>% bind_rows()
    if (nrow(results) == 0) return(NULL)
    results %>% arrange(desc(Coverage))
  }

  return(plots)
}







//////////////////////*************************************#################
---
title: "Rapport QC & Mapping HBV"
output: html_document
---

```{r setup, include=FALSE}
# 📦 Chargement des librairies nécessaires
library(ggplot2)
library(dplyr)
library(readr)
library(stringr)
library(plotly)
library(knitr)
library(here)

# 📁 Charger les fonctions globales de QC
fct_path <- here("src", "scripts_r", "fonctions_globales.R")
if (!file.exists(fct_path)) stop("❌ Le fichier fonctions_globales.R est introuvable.")
source(fct_path)

# 📂 Dossier de base contenant les résultats (à la racine du projet ou workdir)
base_dir <- "results"

# 🔢 Liste des barcodes à traiter
barcodes <- sprintf("barcode%02d", 1:16)

# ⚙️ Génération des graphiques QC
plots <- generate_all_qc_plots(base_dir, barcodes)




## 1. Composition en GC (raw)
```{r}
plots$gc_raw
```

## 2. Longueur des reads (raw)
```{r}
plots$length_raw
```

## 3. Score qualité (Phred) raw
```{r}
plots$phred_raw
```

## 4. Score Phred par position (raw)
```{r}
plots$phred_par_pos_raw
```

## 5.  Composition GC des reads alignés
```{r}
plots$gc_mapped
```

## 6. % Reads mappés vs unmappés
```{r}
plots$reads_mapped_prop
```

## 7. Longueur reads mappés vs unmappés
```{r}
plots$length_mapped
```

##8. Score qualité du mapping
```{r}
plots$map_score
```

##9. Score Phred des reads mappés
```{r}
plots$phred_mapped
```

##10. Heatmap couverture/profondeur
```{r}
plots$coverage_heatmap
```

##11. Tableau de pourcentage de couverture
```{r}
knitr::kable(
  plots$coverage_summary,
  format = "html",
  digits = 1,
  caption = "Pourcentage de couverture par barcode"
)

```













generate_all_qc_plots <- function(base_dir, barcodes) {
  # 📦 Packages nécessaires
  library(readr)
  library(dplyr)
  library(ggplot2)
  library(stringr)
  library(tidyr)
  library(plotly)
  
  plots <- list()
  
  # 1. Composition en GC (raw)
  plots$gc_raw <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "qc_fastq", paste0("output_", bc), paste0(bc, "_GC_content.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      df$barcode <- bc
      df
    }) %>% bind_rows()
    p <- ggplot(df_all, aes(x = GC_content, color = barcode, group = barcode)) +
      geom_density(size = 0.5) +
      labs(title = "1. Composition en GC (raw)", x = "GC (%)", y = "Densité") +
      scale_x_continuous(breaks = seq(0, 100, 10), limits = c(0, 100)) +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }
  
  # 2. Longueur des reads (raw)
  plots$length_raw <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "qc_fastq", paste0("output_", bc), paste0(bc, "_read_length.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      colnames(df) <- "read_length"
      df$barcode <- bc
      df
    }) %>% bind_rows()
    p <- ggplot(df_all, aes(x = read_length, color = barcode, group = barcode)) +
      geom_density(size = 0.5) +
      labs(title = "2. Longueur des reads (raw)", x = "Longueur (bases)", y = "Densité") +
      scale_x_continuous(breaks = seq(100, 1200, 100), limits = c(100, 1200)) +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }
  
  # 3. Score qualité (Phred) raw
  plots$phred_raw <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "qc_fastq", paste0("output_", bc), paste0(bc, "_seq_score.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      colnames(df) <- "seq_score"
      df$barcode <- bc
      df
    }) %>% bind_rows()
    p <- ggplot(df_all, aes(x = seq_score, color = barcode, group = barcode)) +
      geom_density(size = 0.5) +
      labs(title = "3. Score qualité (Phred) raw", x = "Score", y = "Densité") +
      scale_x_continuous(breaks = seq(10, 80, 10), limits = c(10, 80)) +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }
  
  # 4. Score Phred par position (raw)
  plots$phred_by_pos_raw <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "qc_fastq", paste0("output_", bc), paste0(bc, "_per_base_seq_score.txt"))
      if (!file.exists(path)) return(NULL)
      mat <- as.matrix(read.table(path, header = FALSE))
      med <- apply(mat, 2, median, na.rm = TRUE)
      data.frame(position = seq_along(med), score = med, barcode = bc)
    }) %>% bind_rows()
    p <- ggplot(df_all, aes(x = position, y = score, color = barcode)) +
      geom_line(size = 0.7) +
      labs(title = "4. Score Phred par position (raw)", x = "Position", y = "Score qualité") +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }
  
  # 5. Composition GC des reads alignés
  plots$gc_mapped <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "read_alignment_stats", paste0("output_", bc), paste0(bc, "_GC_content.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      colnames(df) <- c("GC_content","mapped","occurence")
      df$barcode <- bc
      df
    }) %>% bind_rows()
    df_m <- df_all %>% mutate(Type = ifelse(mapped == 1, "Mapped", "Unmapped"))
    p <- ggplot(df_m, aes(x = GC_content, weight = occurence, color = barcode, linetype = Type)) +
      geom_density(size = 1) +
      labs(title = "5. Composition GC des reads alignés", x = "GC (%)", y = "Densité") +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }
  
  # 6. Proportion reads mappés vs unmappés
  plots$reads_mapped_prop <- {
    rs <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "read_alignment_stats", paste0("output_", bc), paste0(bc, "_read_count.txt"))
      if (!file.exists(path)) return(NULL)
      lines <- readLines(path)
      if (length(lines) < 2) return(NULL)
      lines <- lines[-1]
      lines <- lines[lines != "" & !grepl("^total", lines, ignore.case = TRUE)]
      mat <- stringr::str_match(lines, "^(.*)\\s+(\\d+)$")
      df <- data.frame(
        read = mat[,2],
        occurence = as.numeric(mat[,3]),
        stringsAsFactors = FALSE
      )
      df %>% mutate(
        Type = ifelse(grepl("no mapped", tolower(read)), "Unmapped", "Mapped"),
        Count = occurence,
        barcode = bc
      )
    }) %>% bind_rows()
    df_s <- rs %>% group_by(barcode) %>% mutate(Proportion = Count / sum(Count) * 100) %>% ungroup()
    p <- ggplot(df_s, aes(x = barcode, y = Proportion, fill = Type)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "6. % reads mappés vs unmappés", y = "Proportion (%)") +
      theme_minimal()
    ggplotly(p, tooltip = "text")
  }
  
  # 7. Longueur reads mappés vs unmappés
  plots$length_mapped <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "read_alignment_stats", paste0("output_", bc), paste0(bc, "_read_length.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      colnames(df) <- c("length","mapped","occurence")
      df <- df %>% filter(occurence > 0)
      df$Type <- ifelse(df$mapped == 1, "Mapped", "Unmapped")
      df$barcode <- bc
      df
    }) %>% bind_rows()
    p <- ggplot(df_all, aes(x = length, weight = occurence, color = barcode, linetype = Type)) +
      geom_density(size = 1) +
      labs(title = "7. Longueur reads mappés vs unmappés", x = "Longueur", y = "Densité") +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }
  
  # 8. Distribution du score de mapping
  plots$map_score <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "read_alignment_stats", paste0("output_", bc), paste0(bc, "_map_score.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      colnames(df) <- c("map_score","mapped","occurence")
      df <- df %>% filter(mapped == 1 & occurence > 0)
      df$barcode <- bc
      df
    }) %>% bind_rows()
    p <- ggplot(df_all, aes(x = map_score, weight = occurence, color = barcode)) +
      geom_density(size = 0.6) +
      labs(title = "8. Score qualité du mapping", x = "Map Score", y = "Densité") +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }
  
  # 9. Score Phred des reads mappés
  plots$phred_mapped <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "read_alignment_stats", paste0("output_", bc), paste0(bc, "_seq_score.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      colnames(df) <- c("seq_score","mapped","occurence")
      df <- df %>% filter(mapped == 1 & occurence > 0)
      df$barcode <- bc
      df
    }) %>% bind_rows()
    p <- ggplot(df_all, aes(x = seq_score, weight = occurence, color = barcode)) +
      geom_density(size = 0.6) +
      labs(title = "9. Score Phred des reads mappés", x = "Phred Score", y = "Densité") +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }
  
  # 10. Heatmap couverture/profondeur
  plots$coverage_heatmap <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "coverage", paste0(bc, ".coverage.bed"))
      if (!file.exists(path)) return(NULL)
      df <- read_tsv(path, col_names = FALSE, show_col_types = FALSE)
      names(df) <- c("Chr","Pos","Depth")
      df$Sample <- bc
      df
    }) %>% bind_rows()
    df <- df_all %>% mutate(
      Class = case_when(
        Depth < 20             ~ "<20X",
        Depth < 30             ~ "20-30X",
        Depth < 50             ~ "30-50X",
        TRUE                    ~ "≥50X"
      )
    )
    df$Class <- factor(df$Class, levels = c("<20X","20-30X","30-50X","≥50X"))
    p <- ggplot(df, aes(x = Pos, y = Sample, fill = Class)) +
      geom_tile() +
      labs(title = "10. Heatmap couverture/profondeur", x = "Position", y = "Échantillon") +
      theme_minimal()
    ggplotly(p, tooltip = "fill")
  }
  
  # 11. Tableau de pourcentage de couverture
  plots$coverage_summary <- {
    results <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "coverage", paste0(bc, ".coverage.bed"))
      if (!file.exists(path)) return(NULL)
      df <- read_tsv(path, col_names = FALSE, show_col_types = FALSE)
      names(df) <- c("Chr","Pos","Depth")
      pct <- sum(df$Depth >= 1) / max(df$Pos, na.rm = TRUE) * 100
      data.frame(barcode = bc, Coverage = round(pct, 1))
    }) %>% bind_rows()
    results %>% arrange(desc(Coverage))
  }
  
  return(plots)
}



---
title: "Rapport QC & Mapping HBV"
output: html_document
---

```{r setup, include=FALSE}
# ─────────── Chargement des librairies ───────────
library(ggplot2)
library(dplyr)
library(readr)
library(stringr)
library(tidyr)
library(plotly)
library(knitr)

# ─────────── Détection du dossier contenant ce .Rmd ───────────
base_dir_rmd <- getwd()

# ─────────── Charger le fichier de fonctions (dans le même dossier que le .Rmd) ───────────
source(file.path(base_dir_rmd, "fonctions_globales.R"))

# ─────────── Définir le dossier des résultats (au niveau du projet) ───────────
base_dir <- file.path(dirname(base_dir_rmd), "results")

# ─────────── Liste des barcodes ───────────
barcodes <- sprintf("barcode%02d", 1:16)

# ─────────── Exécution de la fonction principale ───────────
plots <- generate_all_qc_plots(base_dir, barcodes)









## 1. Composition en GC (raw)
```{r}

plots <- generate_all_qc_plots(base_dir, barcodes)
print("Liste des éléments générés dans plots :")
print(names(plots))

```

## 2. Longueur des reads (raw)
```{r}
plots$length_raw
```

## 3. Score qualité (Phred) raw
```{r}
plots$phred_raw
```

## 4. Score Phred par position (raw)
```{r}
plots$phred_par_pos_raw
```

## 5.  Composition GC des reads alignés
```{r}
plots$gc_mapped
```

## 6. % Reads mappés vs unmappés
```{r}
plots$reads_mapped_prop
```

## 7. Longueur reads mappés vs unmappés
```{r}
plots$length_mapped
```

##8. Score qualité du mapping
```{r}
plots$map_score
```

##9. Score Phred des reads mappés
```{r}
plots$phred_mapped
```

##10. Heatmap couverture/profondeur
```{r}
plots$coverage_heatmap
```

##11. Tableau de pourcentage de couverture
```{r}
knitr::kable(
  plots$coverage_summary,
  format = "html",
  digits = 1,
  caption = "Pourcentage de couverture par barcode"
)

```












##############MAIN.nf corect 
nextflow.enable.dsl=2

// ========== MODULES ==========
include { decompress_archive }     from './modules/decompress_archive.nf'
include { merge_fastq }            from './modules/merge_fastq.nf'
include { trim_reads }             from './modules/trim_reads.nf'
include { parse_fastq_qc }         from './modules/parse_fastq_qc.nf'
include { mapping_bam }            from './modules/mapping_bam.nf'
include { parse_read_align }       from './modules/parse_read_align.nf'  
include { bam_indexing }           from './modules/bam_indexing.nf'
include { bam_coverage }           from './modules/bam_coverage.nf'
include { low_coverage_filtering } from './modules/low_coverage_filtering.nf'
include { variant_calling }        from './modules/variant_calling.nf'
include { parse_variant_qc }       from './modules/parse_variant_qc.nf'
include { consensus_generation }   from './modules/consensus_generation.nf'
//include { GENERATE_REPORT }        from './modules/local/generate_report.nf'

// ========== PARAMÈTRES ==========
params.input        = null
params.sample       = null
params.adapter      = "/home/etudiant/fatemeh/hbv_pipeline/primer/HBV_primer.fasta"
params.ref_genome   = "/home/etudiant/fatemeh/hbv_pipeline/Ref/sequence.fasta"  // Reference genomique
params.result_dir   = "./results"
params.min_len      = 150
params.max_len      = 1200
params.min_qual     = 10
params.cpu          = 4

// ========== DÉTECTION AUTOMATIQUE DU TYPE D’ENTRÉE ==========
def detect_input_type(path) {
    def input_path = file(path)

    if (input_path.name.endsWith('.tar.gz') || input_path.name.endsWith('.zip') || input_path.name.endsWith('.gz')) {
        return decompress_archive(Channel.of(input_path))
            .map { file("decompressed") }
            .map { folder ->
                def subdirs = folder.list().findAll { file("${folder}/${it}").isDirectory() }
                if (subdirs) {
                    println "🔹 Dossier multiplex détecté après décompression"
                    def grouped = file("${folder}/*/*.fastq.gz").groupBy { it.parent.name }
                    grouped.collect { name, list -> tuple(name, list.sort()) }
                } else {
                    println "🔹 Dossier plat détecté après décompression"
                    [ tuple("sample", file("${folder}/*.fastq.gz").sort()) ]
                }
            }
            .flatten()
    }

    else if (input_path.isDirectory() && !input_path.list().any { file("${input_path}/${it}").isDirectory() }) {
        println "🔹 Dossier plat détecté"
        def files = file("${input_path}/*.fastq.gz").sort()
        return Channel.of(tuple("sample", files))
    }

    else if (input_path.isDirectory() && input_path.list().any { file("${input_path}/${it}").isDirectory() }) {
        println "🔹 Dossier multiplex détecté"
        def grouped = file("${input_path}/*/*.fastq.gz").groupBy { it.parent.name }
        def tuples = grouped.collect { name, list -> tuple(name, list.sort()) }
        return Channel.from(tuples)
    }

    else if (input_path.name.endsWith('.fastq.gz')) {
        println "🔹 Fichier unique FASTQ détecté"
        def sample_name = params.sample ?: input_path.baseName
        return Channel.of(tuple(sample_name, [input_path]))
    }

    else {
        error "❌ Chemin d’entrée invalide ou non supporté : ${params.input}"
    }
}

// ========== WORKFLOW PRINCIPAL ==========
workflow {
    fastq_ch = detect_input_type(params.input)

    merged_fastq_ch = merge_fastq(fastq_ch)

    trimmed_fastq_ch = trim_reads(
        merged_fastq_ch,
        file(params.adapter),
        params.min_len,
        params.max_len,
        params.min_qual,
        params.cpu                              
    )

    parse_fastq_qc(trimmed_fastq_ch)      



    mapped_bam_ch = mapping_bam(trimmed_fastq_ch, file(params.ref_genome), params.cpu)


    parse_read_align(mapped_bam_ch)

    indexed_bam_ch = bam_indexing(mapped_bam_ch)

    coverage_ch = bam_coverage(
    mapped_bam_ch.map { id, bam, sam -> tuple(id, bam) },
    file(params.ref_genome)
    )

    lowcov_ch = coverage_ch.map { sample_id, bedfile -> 
    tuple(sample_id, bedfile)
}
    lowcov_filtered = low_coverage_filtering(lowcov_ch)

 


    variant_input_ch = mapped_bam_ch
        .map { sample_id, bam, sam -> tuple(sample_id, bam) }
        .join(
          indexed_bam_ch.map { sample_id, bai -> tuple(sample_id, bai) }
    )
        .map { sample_id, bam, bai -> tuple(sample_id, bam, bai) }

        variant_ch = variant_calling(variant_input_ch, file(params.ref_genome))

    


    variant_qc_input_ch = variant_ch
    .join(mapped_bam_ch.map { id, bam, sam -> tuple(id, bam) })
    .map { id, vcf, vcf_idx, bam -> tuple(id, vcf, vcf_idx, bam) }

    variant_qc_ch = parse_variant_qc(variant_qc_input_ch, file(params.ref_genome))








   

    consensus_input_ch = variant_ch
        .join(lowcov_ch)
       .map { sample_id, vcf, tbi, bed ->
            tuple(sample_id, vcf, tbi, file(params.ref_genome), bed)
        }

    consensus_fa_ch = consensus_generation(consensus_input_ch)















    ***************************ca fonction important 
    process consensus_generation {

    input:
    tuple val(sample_id), path(vcf), path(tbi), path(ref_genome), path(lowcov_bed)

    output:
    path("${sample_id}.consensus.fa")
    path("${sample_id}.tmp.fa")

    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    set -e

    # Étape 1 : Générer la séquence consensus à partir du VCF
    bcftools consensus -f ${ref_genome} ${vcf} > ${sample_id}.tmp.fa

    # Étape 2 : Filtrer le fichier BED (important pour éviter les erreurs)
    awk '\$2 < \$3' ${lowcov_bed} > ${sample_id}.lowcov.valid.bed

    # Étape 3 : Masquer les régions à faible couverture
    bedtools maskfasta -fi ${sample_id}.tmp.fa -bed ${sample_id}.lowcov.valid.bed -fo ${sample_id}.consensus.fa
    """
}





# ///////////ca fonction aussi avec main vert*****************************

process consensus_generation {

    input:
    tuple val(sample_id), path(vcf), path(tbi), path(ref_genome), path(lowcov_bed)

    output:
    path("${sample_id}.consensus.fa")
    path("${sample_id}.tmp.fa")
    path("${sample_id}.lowcov.valid.bed") // exporté pour vérification si tu veux

    publishDir "${params.result_dir ?: './results'}/${sample_id}", mode: 'copy'

    script:
    """
    set -e

    # Étape 1 : Générer la séquence consensus à partir du VCF
    bcftools consensus -f ${ref_genome} ${vcf} > ${sample_id}.tmp.fa

    # Étape 2 : Filtrer le fichier BED pour garder uniquement les lignes valides
    awk '\$2 < \$3' ${lowcov_bed} > ${sample_id}.lowcov.valid.bed

    # Étape 3 : Masquer les régions à faible couverture
    bedtools maskfasta -fi ${sample_id}.tmp.fa -bed ${sample_id}.lowcov.valid.bed -fo ${sample_id}.consensus.fa
    """
}









# *******ca marche pas 
/// 🔹 Préparation des entrées pour le consensus
consensus_input_ch = variant_ch
    .join(lowcov_filtered, by: 0)  // join forcé par sample_id
    .map { sample_id, vcf, tbi, bed ->
        tuple(sample_id, vcf, tbi, file(params.ref_genome), bed)
    }
    .view { "🧩 consensus input: $it" } // debug visible

// 🔹 Lancer le process
consensus_fa_ch = consensus_generation(consensus_input_ch)

}






r****************
---
title: "Rapport QC & Mapping HBV"
author: "Fatemeh Kazemi"
date: "`r Sys.Date()`"
output:
  html_document:
    toc: true
    toc_depth: 2
    theme: united
---

```{r setup, include=FALSE}
# Chargement des librairies nécessaires
library(ggplot2)
library(dplyr)
library(readr)
library(stringr)
library(tidyr)
library(plotly)
library(knitr)
library(scales)
library(kableExtra)

# Importer les fonctions depuis le même dossier (src/)
source("fonctions_globales.R")

#  Définir le chemin vers les résultats (ex: src/results/barcode01)
#base_dir <- "results"


#  Lire les chemins depuis les variables d’environnement (transmis par Python/Nextflow)

base_dir_rmd <- Sys.getenv("BASE_DIR_RMD")
output_dir_rmd <- Sys.getenv("OUTPUT_DIR_RMD")

#  Générer la liste des barcodes : barcode01 à barcode16
#barcodes <- sprintf("barcode%02d", 1:16)

barcodes <- list.dirs(path = file.path(base_dir_rmd), full.names = FALSE, recursive = FALSE)

barcodes <- barcodes[grepl("^barcode", barcodes)]


#  Générer les graphiques interactifs
#plots <- 
(base_dir, barcodes)

base_dir <- base_dir_rmd


plots <- suppressMessages(generate_all_qc_plots(base_dir, barcodes))





********************************c fonctionn 

generate_all_qc_plots <- function(base_dir, barcodes) {
  # Packages nécessaires
  library(readr)
  library(dplyr)
  library(ggplot2)
  library(stringr)
  library(tidyr)
  library(plotly)
  
  plots <- list()
  
  # 1. Composition en GC (raw)
  plots$gc_raw <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "qc_fastq", paste0("output_", bc), paste0(bc, "_GC_content.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      df$barcode <- bc
      df
    }) %>% bind_rows()
    p <- ggplot(df_all, aes(x = GC_content, color = barcode, group = barcode)) +
      geom_density(size = 0.5) +
      labs(title = "1. Composition en GC (raw)", x = "GC (%)", y = "Densité") +
      scale_x_continuous(breaks = seq(0, 100, 10), limits = c(0, 100)) +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }





  # 1. Composition en GC (raw)
  plots$gc_raw <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "qc_fastq", paste0("output_", bc), paste0(bc, "_GC_content.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      df$barcode <- bc
      df
    }) %>% bind_rows()
    p <- ggplot(df_all, aes(x = GC_content, color = barcode, group = barcode)) +
      geom_density(size = 0.5) +
      labs(title = "1. Composition en GC (raw)", x = "GC (%)", y = "Densité") +
      scale_x_continuous(breaks = seq(0, 100, 10), limits = c(0, 100)) +
      theme_minimal()
    ggplotly(p, tooltip = "colour")
  }
  





#********************************************************************************************************
**********************************************************************pas relatif mais cafonction pas 
  # Récupération des chemins depuis Nextflow / variables d’environnement
base_dir_rmd   <- Sys.getenv("BASE_DIR_RMD")
output_dir_rmd <- Sys.getenv("OUTPUT_DIR_RMD")  # si besoin ailleurs

# Construction de la liste des barcodes
barcodes <- list.dirs(
  path       = base_dir_rmd,
  full.names = FALSE,
  recursive  = FALSE
) %>% keep(~ str_detect(.x, "^barcode"))

# Génération des graphiques
plots <- generate_all_qc_plots(base_dir_rmd, barcodes)


#/////////////////////////////////////////////////////////////////

ca fonction *********

#!/usr/bin/env python3

import argparse
import subprocess
import os
import sys

# 🔍 Vérifie que les fichiers de sortie sont bien générés
def check_pipeline_outputs(result_dir, barcodes):
    for bc in barcodes:
        path = os.path.join(result_dir, bc, "qc_fastq", f"output_{bc}", f"{bc}_GC_content.txt")
        if not os.path.exists(path):
            print(f"❌ Fichier manquant : {path}")
            return False
    return True

def main():
    parser = argparse.ArgumentParser(description="Lancer le pipeline Nextflow depuis src et générer un rapport HTML.")
    parser.add_argument('--input', required=True, help="Chemin vers les données d'entrée (ex: data_test/hbv)")
    parser.add_argument('--result_dir', default='results', help="Dossier pour les résultats du pipeline")
    parser.add_argument('--rmd', default='src/rapport_final.Rmd', help="Chemin vers le fichier .Rmd")
    parser.add_argument('--output_dir', default='results/reports', help="Dossier pour le rapport HTML final")

    args = parser.parse_args()

    # 📁 Convertir les chemins relatifs en chemins absolus
    input_path   = os.path.abspath(args.input)
    result_dir   = os.path.abspath(args.result_dir)
    rmd_path     = os.path.abspath(args.rmd)
    output_dir   = os.path.abspath(args.output_dir)

    # 📌 Trouver le chemin absolu de main.nf dans le dossier src
    main_nf_path = os.path.join(os.path.dirname(__file__), "main.nf")

    # 1️⃣ Exécuter le pipeline Nextflow
    print("▶️ Lancement du pipeline Nextflow...")
    try:
        subprocess.run([
            "nextflow", "run", main_nf_path,
            "--input", input_path,
            "--result_dir", result_dir
        ], check=True)
        print("✅ Pipeline terminé avec succès.\n")
    except subprocess.CalledProcessError:
        print("❌ Erreur lors de l'exécution du pipeline.")
        sys.exit(1)

    # 2️⃣ Vérifier que les fichiers nécessaires ont été générés
    barcodes = [f"barcode{str(i).zfill(2)}" for i in range(1, 17)]
    if not check_pipeline_outputs(result_dir, barcodes):
        print("⚠️ Le rapport HTML ne sera pas généré : fichiers manquants.")
        sys.exit(1)

    # 3️⃣ Définir les variables d'environnement pour RMarkdown
    os.environ['BASE_DIR_RMD'] = result_dir
    os.environ['OUTPUT_DIR_RMD'] = output_dir

    # 4️⃣ Lancer la génération du rapport HTML avec RMarkdown
    print("📄 Génération du rapport HTML...")
    try:
        subprocess.run([
            "Rscript", "-e",
            f"rmarkdown::render('{rmd_path}', output_dir='{output_dir}')"
        ], check=True)
        print("✅ Rapport HTML généré avec succès dans :", output_dir)
    except subprocess.CalledProcessError:
        print("❌ Une erreur est survenue lors de la génération du rapport HTML.")
        sys.exit(1)

if __name__ == "__main__":
    main()
