library(dplyr)
library(readr)
library(ggplot2)
library(ggplotify)
library(readxl)
library(msigdb)
library(biomaRt)
library(tidyr)
library(powerjoin)
library(plotly)
library(htmlwidgets)
library(purrr)
library(sjPlot)

args <- commandArgs(trailingOnly = TRUE)
file <- args[[1]]
pacient <- args[[2]]
out_dir <- args[[3]]

data <- read_table(file,
                   col_names = c("chromosome_name", "coord", "depth"))

var <- read_xlsx("/mnt/raid/Shared/bed_dir_1.2/R_files/transkripcni_varianty2.xlsx", sheet=1)  |> 
  dplyr::select(TV) |> unlist() |> as.vector()

exon_file <- "/mnt/raid/Shared/bed_dir_1.2/R_files/exon.csv"
transcript_file <- "/mnt/raid/Shared/bed_dir_1.2/R_files/transcript.csv"
gene_file <- "/mnt/raid/Shared/bed_dir_1.2/R_files/gene.csv"

if (file.exists(exon_file)) {
    message("Read from /mnt/raid/Shared/bed_dir_1.2/R_files")
    exon <- read_csv(exon_file, show_col_types = FALSE)
    transcript <- read_csv(transcript_file, show_col_types = FALSE)
    gene <- read_csv(gene_file, show_col_types = FALSE)
 } else {
     message("Local files not found, try Ensembl DB")
     #mart <- biomaRt::useMart(
     #  biomart = "ensembl",
     #  dataset = "hsapiens_gene_ensembl",
     #  host = "https://grch37.ensembl.org",
     #  path = "/biomart/martservice"
     #)

     mart <- useEnsembl(
       biomart = "genes",
       dataset = "hsapiens_gene_ensembl",
       GRCh = 37
     )

     attr_exon <- c("rank", "exon_chrom_start", "exon_chrom_end", "ensembl_exon_id",
                    "cdna_coding_start", "cdna_coding_end",
                    "cds_start", "cds_end")

     exon <- getBM(attributes=attr_exon,
                   filters = "refseq_mrna", values = var, mart = mart)

     attr_transcript <- c(
       "refseq_mrna",
       "transcript_start", "transcript_end",
       "ensembl_exon_id")

     transcript <- getBM(attributes=attr_transcript,
                         filters = "refseq_mrna", values = var, mart = mart)

     attr_gene <- c("refseq_mrna", "hgnc_symbol", "strand", "chromosome_name")
     gene <- getBM(attributes=attr_gene,
                   filters = "refseq_mrna", values = var, mart = mart)

     write.csv(exon, file = exon_file, row.names = FALSE)
     write.csv(transcript, file = transcript_file, row.names = FALSE)
     write.csv(gene, file = gene_file, row.names = FALSE)
 }

all <- gene |>
  power_right_join(transcript, by = "refseq_mrna", conflict = coalesce_xy) |>
  power_right_join(exon, by = "ensembl_exon_id") |>
  mutate(chromosome_name = paste0("chr", chromosome_name)) |>
  mutate(cds_length = (cds_end - cds_start) + 1)

exon_1 <- all |>
  select(refseq_mrna, strand, hgnc_symbol, rank, exon_chrom_start, exon_chrom_end, cds_end, cds_start) |>
  filter(!is.na(cds_end)) |>
  group_by(refseq_mrna, hgnc_symbol) |>
  filter(rank == min(rank)) |>
  mutate(cds_coord_start = if_else(strand == 1, exon_chrom_end - cds_end + 1,
                                   exon_chrom_start + cds_end - 1)) |>
  mutate(cds_coord_end = if_else(strand == 1, exon_chrom_end, exon_chrom_start)) |>
  mutate(exon_1 = 1)

exon_999 <- all |>
  select(refseq_mrna, strand, hgnc_symbol, rank, exon_chrom_start, exon_chrom_end, cds_end, cds_start) |>
  filter(!is.na(cds_end)) |>
  group_by(refseq_mrna, hgnc_symbol) |>
  filter(rank == max(rank)) |>
  mutate(cds_coord_end = if_else(strand == 1, exon_chrom_start + (cds_end - cds_start), exon_chrom_end - (cds_end - cds_start))) |>
  mutate(cds_coord_start = if_else(strand == 1, exon_chrom_start, exon_chrom_end)) |>
  mutate(exon_999 = 1)

coord_gene_coding <- all |>
  arrange(hgnc_symbol) |>
  mutate(cds_coord_start = case_when(
    strand == 1 & !is.na(cds_end) ~ exon_chrom_start,
    strand == -1 & !is.na(cds_end) ~ exon_chrom_end)) |>
  mutate(cds_coord_end = case_when(
    strand == 1 & !is.na(cds_end) ~ exon_chrom_end,
    strand == -1 & !is.na(cds_end) ~ exon_chrom_start))

coord_gene_no_c <- coord_gene_coding |>
  select(-c(matches("cds"))) |>
  power_left_join(exon_1, by = c("refseq_mrna", "rank"), conflict = coalesce_yx) |>
  power_left_join(exon_999, by = c("refseq_mrna", "rank"), conflict = coalesce_yx) |>
  rowwise() |>
  mutate(coord = list(seq(from = exon_chrom_start, to = exon_chrom_end, by = 1))) |>
  unnest_longer(coord)

coord_gene_c_plus <- coord_gene_coding |>
  power_left_join(exon_1, by = c("refseq_mrna", "rank"), conflict = coalesce_yx) |>
  power_left_join(exon_999, by = c("refseq_mrna", "rank"), conflict = coalesce_yx) |>
  select(refseq_mrna, strand, matches("cds")) |>
  filter(!is.na(cds_start) & strand == 1) |>
  rowwise() |>
  mutate(cds_coord = list(seq(from = cds_coord_start, to = cds_coord_end, by = 1))) |>
  mutate(c.cds_coord = list(seq(from = cds_start, to = cds_end, by = 1))) |>
  unnest_longer(c(cds_coord, c.cds_coord)) |>
  mutate(c.cds_coord = paste0("c.", c.cds_coord))

coord_gene_c_minus <- coord_gene_coding |>
  power_left_join(exon_1, by = c("refseq_mrna", "rank"), conflict = coalesce_yx) |>
  power_left_join(exon_999, by = c("refseq_mrna", "rank"), conflict = coalesce_yx) |>
  select(refseq_mrna, strand, matches("cds")) |>
  filter(!is.na(cds_start) & strand == -1) |>
  rowwise() |>
  mutate(cds_coord = list(seq(from = cds_coord_start, to = cds_coord_end, by = -1))) |>
  mutate(c.cds_coord = list(seq(from = cds_start, to = cds_end, by = 1))) |>
  unnest_longer(c(cds_coord, c.cds_coord)) |>
  mutate(c.cds_coord = paste0("c.", c.cds_coord))

coord_gene_c <- coord_gene_c_plus |> bind_rows(coord_gene_c_minus) |>
  mutate(coord = cds_coord)

coord_gene <- coord_gene_no_c |>
  power_left_join(coord_gene_c, by = c("coord", "refseq_mrna"), conflict = coalesce_xy)

depth <- data |> power_left_join(coord_gene,
                                 by = c("coord", "chromosome_name"),
                                 conflict = coalesce_xy) |>
  filter(!is.na(refseq_mrna)) |>
  group_by(hgnc_symbol, refseq_mrna, rank)

modraky <- function(var, depth){

  varianta <- var
  depth_fil <- depth |> filter(refseq_mrna == varianta) |>
    mutate(coord = as.numeric(as.character(coord)))

  gene <- depth_fil |>
    ungroup() |>
    select(hgnc_symbol) |>
    distinct() |> unlist() |> as.vector()

  strand <- depth_fil |>
    ungroup() |>
    select(strand) |>
    distinct() |> unlist() |> as.vector()

  if(strand == -1){
    p <- ggplot(depth_fil, aes(x = coord, y = depth, text = paste("c.coord:", c.cds_coord))) +
      labs(title = gene,
           subtitle = varianta) +
      geom_col(fill = "lightblue", position = "dodge") +
      geom_segment(aes(x = cds_coord_start, xend = cds_coord_end, y = 0, yend = 0),
                   color = "pink", size = 1) +
      scale_x_reverse() +
      facet_grid(~rank, scales = "free", space = "free", switch = "x") +
      geom_hline(yintercept = 10, linetype = "dashed", color = "pink") +
      geom_hline(yintercept = 100, linetype = "dashed", color = "pink") +
      theme(
        plot.title = element_text(size = 20, hjust = 0.5),
        plot.subtitle = element_text(size = 10, hjust = 0.5),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.x = element_blank(),
        panel.background = element_rect(fill = 'white'),
        panel.spacing.x = unit(0.1, "lines"),
        strip.background = element_rect(fill="grey", size=90),
        strip.text.x = element_text(size = 8, colour = "black", angle = 0),
        text = element_text(size = 30)
      )
  } else {
    p <- ggplot(depth_fil, aes(x = coord, y = depth, text = paste("c.coord:", c.cds_coord))) +
      labs(title = gene,
           subtitle = varianta) +
      geom_col(fill = "lightblue", position = "dodge") +
      geom_segment(aes(x = cds_coord_start, xend = cds_coord_end, y = 0, yend = 0),
                   color = "pink", size = 1) +
      facet_grid(~rank, scales = "free", space = "free", switch = "x") +
      geom_hline(yintercept = 10, linetype = "dashed", color = "pink") +
      geom_hline(yintercept = 100, linetype = "dashed", color = "pink") +
      # geom_vline(aes(xintercept = cds_min), color = "grey", linetype = "dashed") +
      # geom_vline(aes(xintercept = cds_max), color = "grey", linetype = "dashed") +
      theme(
        plot.title = element_text(size = 20, hjust = 0.5),
        plot.subtitle = element_text(size = 10, hjust = 0.5),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.title.x = element_blank(),
        panel.background = element_rect(fill = 'white'),
        panel.spacing.x = unit(0.1, "lines"),
        #plot.margin = margin(0, 0, 0, 0),
        strip.background = element_rect(fill="grey", size=90),
        strip.text.x = element_text(size = 8, colour = "black", angle = 0),
        text = element_text(size = 30)
      )
  }

  return(p)
}

plot <- var |> map(modraky, depth) |>
  setNames(var)

plot |>
  map2(names(plot), function(x, y){
    nm <- y
    ggsave(paste0(out_dir, pacient, nm, ".png"), x, width = 25, height = 10)

    plotly <- ggplotly(x)
    saveWidget(plotly, paste0(out_dir, pacient, nm, ".html"))
  })

