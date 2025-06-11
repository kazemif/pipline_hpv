# fonctions_globales.R

# Packages nécessaires
library(readr)
library(dplyr)
library(ggplot2)
library(stringr)
library(tidyr)
library(plotly)

# Génère la liste des plots QC pour un ensemble de barcodes
generate_all_qc_plots <- function(base_dir, barcodes) {
  plots <- list()

  
  plots$gc_raw <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "qc_fastq", paste0("output_", bc),
                        paste0(bc, "_GC_content.txt"))
      if (!file.exists(path)) return(NULL)
      
      # Lecture du fichier (on suppose qu'il y a une colonne "GC_content")
      df <- tryCatch({
        read_csv(path, show_col_types = FALSE)
      }, error = function(e) {
        return(NULL)
      })
      
      # Si la colonne exacte "GC_content" n'existe pas, on tente un renommage
      if (!"GC_content" %in% colnames(df)) {
        # Exemple : si le fichier a 1 seule colonne sans nom,
        # on la renomme en "GC_content".
        if (ncol(df) == 1) {
          colnames(df)[1] <- "GC_content"
        } else {
          # On ne peut pas tracer ce fichier : on l'ignore
          return(NULL)
        }
      }
      
      # Ajout du nom de barcode pour l'affichage
      df$barcode <- bc
      df
    }) %>% bind_rows()
    
    # Si aucune donnée valide n'a été lue, on renvoie NULL
    if (nrow(df_all) == 0) return(NULL)
    
    # À ce stade, df_all contient au moins la colonne "GC_content" et "barcode"
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
  
  # 4. Score Phred par position (raw) - version lissée sans vérification de fichier
  plots$phred_by_pos_raw <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "qc_fastq", paste0("output_", bc), paste0(bc, "_per_base_seq_score.txt"))
      mat <- as.matrix(read.table(path, header = FALSE))
      med <- apply(mat, 2, median, na.rm = TRUE)
      data.frame(position = seq_along(med), score = med, barcode = bc)
    }) %>% bind_rows()
    
    df_all <- df_all %>% filter(!is.na(score))
    
    p <- ggplot(df_all, aes(x = position, y = score, color = barcode)) +
      geom_smooth(se = FALSE, method = "loess", span = 0.3, linewidth = 0.6) +
      labs(
        title = "4. Score Phred par position (raw)",
        x = "Position du read",
        y = "Score qualité (Phred)"
      ) +
      scale_y_continuous(limits = c(0, 80)) +
      theme_minimal()
    
    ggplotly(p, tooltip = "colour")
  }
  
  
  
  # 5. Composition GC des reads alignés (sécurisé pour pipeline)
  plots$gc_mapped <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "read_alignment_stats", paste0("output_", bc), paste0(bc, "_GC_content.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      colnames(df) <- c("GC_content", "mapped", "occurence")
      df$barcode <- bc
      df
    }) %>% bind_rows()
    
    df_m <- df_all %>% mutate(Type = ifelse(mapped == 1, "Mapped", "Unmapped"))
    
    p <- ggplot(df_m, aes(x = GC_content, weight = occurence, color = barcode, linetype = Type)) +
      geom_density(adjust = 2, size = 0.3) +
      labs(title = "5. Composition GC des reads alignés", x = "GC (%)", y = "Densité") +
      theme_minimal()
    
    ggplotly(p, tooltip = "colour")
  }
  
  
  # 6. Proportion reads mappés vs unmappés (version améliorée)
  plots$reads_mapped_prop <- {
    library(stringr)
    
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
    
    # Calcul des proportions et ordre des barcodes
    df_s <- rs %>%
      group_by(barcode) %>%
      mutate(Proportion = Count / sum(Count) * 100) %>%
      ungroup()
    
    df_s$barcode <- factor(df_s$barcode, levels = rev(unique(barcodes)))
    
    # Création du graphique ggplot
    p <- ggplot(df_s, aes(x = barcode, y = Proportion, fill = Type, text = paste0(Type, ": ", round(Proportion, 1), "%"))) +
      geom_bar(stat = "identity", position = "stack") +
      coord_flip() +
      scale_fill_manual(values = c("Mapped" = "lightgreen", "Unmapped" = "firebrick")) +
      labs(
        title = "6. % reads mappés vs unmappés",
        y = "Proportion (%)",
        x = NULL
      ) +
      theme_minimal() +
      theme(
        plot.title = element_text(size = 14, face = "bold"),
        legend.title = element_blank()
      )
    
    # Graphique interactif avec pourcentage au survol
    ggplotly(p, tooltip = "text")
  }
  
  
  # 7. Longueur reads mappés vs unmappés (version lissée et fine)
  plots$length_mapped <- {
    df_all <- lapply(barcodes, function(bc) {
      path <- file.path(base_dir, bc, "read_alignment_stats", paste0("output_", bc), paste0(bc, "_read_length.txt"))
      if (!file.exists(path)) return(NULL)
      df <- read_csv(path, show_col_types = FALSE)
      colnames(df) <- c("length", "mapped", "occurence")
      df <- df %>% filter(occurence > 0)
      df$Type <- ifelse(df$mapped == 1, "Mapped", "Unmapped")
      df$barcode <- bc
      df
    }) %>% bind_rows()
    
    p <- ggplot(df_all, aes(x = length, weight = occurence, color = barcode, linetype = Type)) +
      geom_density(adjust = 3, size = 0.4) +  # ← ajustement pour courbe plus douce et fine
      scale_y_continuous(labels = number_format(accuracy = 0.0001)) +  # Format lisible automatique
      labs(
        title = "7. Longueur reads mappés vs unmappés",
        x = "Longueur des reads (b)",
        y = "Densité"
      ) +
      scale_x_continuous(limits = c(0, 1250)) +
      theme_minimal() +
      theme(
        plot.title = element_text(size = 14, face = "bold"),
        legend.text = element_text(size = 8),
        legend.title = element_text(size = 10)
      )
    
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