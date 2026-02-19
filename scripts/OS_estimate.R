pkgs <- c(
  "TCGAbiolinks", "SummarizedExperiment", "dplyr", "tibble", "stringr",
  "survival", "survminer", "maxstat", "ggplot2",
  "estimate", "readr"
)

to_install <- pkgs[!pkgs %in% rownames(installed.packages())]
if (length(to_install)) install.packages(to_install, repos = "https://cloud.r-project.org")

# Bioconductor packages (TCGAbiolinks)
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
if (!requireNamespace("TCGAbiolinks", quietly = TRUE)) BiocManager::install("TCGAbiolinks")

lapply(pkgs, library, character.only = TRUE)

install.packages("estimate", repos="http://R-Forge.R-project.org")
#install.packages("Downloads/estimate_1.0.13.tar.gz", repos = NULL, type = "source")


library(utils)
rforge <- "http://r-forge.r-project.org"
install.packages("estimate", repos=rforge, dependencies=TRUE)


project <- "TCGA-PAAD"

PROJECT <- "TCGA-PAAD"

# Choose which STAR assay to use for "raw counts"
# Common: "unstranded" (recommended), "stranded_first", "stranded_second"
STAR_COUNT_ASSAY <- "unstranded"

# Which clinical covariates to attempt adjusting for (kept only if present & not all NA)
DEFAULT_COVARS <- c(
  "age_years",
  "gender",                 # may be "gender" or "sex"
  "ajcc_pathologic_stage",  # messy but usable
  "TumorPurity",
  "StromalScore",
  "ImmuneScore"
)

#---------------------------
# 1) Download expression (STAR - Counts) + clinical
#---------------------------
query <- GDCquery(
  project = PROJECT,
  data.category = "Transcriptome Profiling",
  data.type = "Gene Expression Quantification",
  workflow.type = "STAR - Counts"
)

GDCdownload(query)
se <- GDCprepare(query)
########
clin <- GDCquery_clinic(project = PROJECT, type = "clinical")

#---------------------------
# 2) Extract tpm
#---------------------------
expr <- assay(se, "tpm_unstrand")

# Keep primary tumor samples only
barcodes_tp <- TCGAquery_SampleTypes(colnames(expr), typesample = "TP")
expr <- expr[, barcodes_tp]

# Map gene symbols
rowdat <- as.data.frame(rowData(se))
gene_symbol <- rowdat$gene_name
rownames(expr) <- gene_symbol

# Collapse duplicate symbols (mean is better for TPM)
expr_df <- as.data.frame(expr) %>%
  tibble::rownames_to_column("gene") %>%
  filter(!is.na(gene) & gene != "") %>%
  group_by(gene) %>%
  summarise(across(where(is.numeric), mean), .groups = "drop") %>%
  column_to_rownames("gene")

expr <- as.matrix(expr_df)

# Log transform
expr <- log2(expr + 1)

# ---------------------------
# 2) Clinical + OS endpoint
# ---------------------------
clin <- GDCquery_clinic(project = PROJECT, type = "clinical")

clin2 <- clin %>%
  mutate(
    patient = coalesce(submitter_id, bcr_patient_barcode),
    age_years = age_at_diagnosis / 365.25
  ) %>%
  select(patient, vital_status, days_to_death, days_to_last_follow_up,
         age_years, gender, ajcc_pathologic_stage) %>%
  distinct(patient, .keep_all = TRUE)

patient_id <- substr(colnames(expr), 1, 12)

surv_df <- tibble(sample = colnames(expr), patient = patient_id) %>%
  left_join(clin2, by = "patient") %>%
  mutate(
    OS_time  = if_else(!is.na(days_to_death), days_to_death, days_to_last_follow_up),
    OS_event = if_else(tolower(vital_status) == "dead", 1L, 0L),
    gender = factor(gender),
    stage_simple = case_when(
      str_detect(ajcc_pathologic_stage, regex("^stage i\\b",  ignore_case = TRUE)) ~ "I",
      str_detect(ajcc_pathologic_stage, regex("^stage ii\\b", ignore_case = TRUE)) ~ "II",
      str_detect(ajcc_pathologic_stage, regex("^stage iii\\b",ignore_case = TRUE)) ~ "III",
      str_detect(ajcc_pathologic_stage, regex("^stage iv\\b", ignore_case = TRUE)) ~ "IV",
      TRUE ~ NA_character_
    ),
    stage_simple = factor(stage_simple, levels = c("I","II","III","IV"))
  ) %>%
  filter(!is.na(OS_time) & OS_time > 0)

# Align expression to survival samples
expr <- expr[, surv_df$sample, drop = FALSE]
cat("PAAD tumor samples with OS:", nrow(surv_df), "\n")

# ---------------------------
# 3) Read score file (use as-is, NO recompute)
# ---------------------------

score_raw <- readr::read_csv("PAAD_Estimate.csv", show_col_types = FALSE)

# Make column names easy to match regardless of casing / punctuation
score <- score_raw
names(score) <- names(score) %>%
  str_replace_all("[^A-Za-z0-9]+", "_") %>%
  str_replace_all("_+$", "") %>%
  tolower()

# Identify sample ID column (common: id, sample, barcode)
id_col <- intersect(c("id", "sample", "barcode", "tcga_id"), names(score))[1]
if (is.na(id_col)) {
  stop("Could not find an ID column in score file. Expected one of: id, sample, barcode, tcga_id")
}

score <- score %>%
  rename(sample = !!id_col)

# Keep only score columns that exist in your file (examples shown)
# (No recomputation; just rename if present)
rename_map <- c(
  "stromal_score" = "stromalscore",
  "immune_score" = "immunescore",
  "estimate_score" = "estimatescore",
  "tumor_purity" = "tumorpurity"
)

for (nm in names(rename_map)) {
  if (rename_map[[nm]] %in% names(score) && !(nm %in% names(score))) {
    score <- score %>% rename(!!nm := !!rename_map[[nm]])
  }
}

# Merge scores into survival table (by sample barcode like TCGA-XX-XXXX-01...)
surv_df <- surv_df %>% left_join(score, by = "sample")

# OPTIONAL: if you want to require scores, uncomment:
# surv_df <- surv_df %>% filter(!is.na(stromal_score) & !is.na(immune_score))

# ---------------------------
# 4) Survival helpers
# ---------------------------
prep_covars <- function(dat, covars) {
  covars <- intersect(covars, colnames(dat))
  covars <- covars[sapply(dat[covars], function(x) {
    if (all(is.na(x))) return(FALSE)
    ux <- unique(na.omit(x))
    length(ux) >= 2
  })]
  covars
}

# Choose covariates that exist (will be auto-filtered)
DEFAULT_COVARS <- c("age_years", "gender", "stage_simple",
                    "tumor_purity", "stromal_score", "immune_score", "estimate_score")

run_gene_survival <- function(gene, method = c("median", "quantile", "maxstat"),
                              q = c(0.25, 0.75), minprop = 0.25,
                              adjust_covars = DEFAULT_COVARS) {
  method <- match.arg(method)
  if (!gene %in% rownames(expr)) stop(paste("Gene not found:", gene))
  
  dat <- surv_df %>%
    mutate(gene_expr = as.numeric(expr[gene, sample])) %>%
    filter(!is.na(gene_expr))
  
  cutoff <- NA
  
  if (method == "median") {
    cutoff <- median(dat$gene_expr, na.rm = TRUE)
    dat <- dat %>% mutate(group = ifelse(gene_expr > cutoff, "High", "Low"))
  } else if (method == "quantile") {
    qs <- quantile(dat$gene_expr, probs = q, na.rm = TRUE)
    cutoff <- qs
    dat <- dat %>%
      mutate(group = case_when(
        gene_expr <= qs[1] ~ "Low",
        gene_expr >= qs[2] ~ "High",
        TRUE ~ NA_character_
      )) %>%
      filter(!is.na(group))
  } else {
    ms <- maxstat::maxstat.test(
      Surv(OS_time, OS_event) ~ gene_expr,
      data = dat,
      smethod = "LogRank",
      pmethod = "exactGauss",
      minprop = minprop
    )
    cutoff <- as.numeric(ms$estimate)
    dat <- dat %>% mutate(group = ifelse(gene_expr > cutoff, "High", "Low"))
  }
  
  dat$group <- factor(dat$group, levels = c("Low", "High"))
  
  km_fit <- survfit(Surv(OS_time, OS_event) ~ group, data = dat)
  cox_unadj <- coxph(Surv(OS_time, OS_event) ~ group, data = dat)
  
  covars_used <- prep_covars(dat, adjust_covars)
  cox_adj <- NULL
  if (length(covars_used) > 0) {
    fml <- as.formula(paste0("Surv(OS_time, OS_event) ~ group + ", paste(covars_used, collapse = " + ")))
    cox_adj <- coxph(fml, data = dat)
  }
  
  list(gene = gene, method = method, cutoff = cutoff, n = nrow(dat),
       data = dat, km_fit = km_fit, cox_unadj = cox_unadj,
       cox_adj = cox_adj, covars_used = covars_used)
}

print_hr <- function(fit) {
  s <- summary(fit)
  hr <- exp(coef(fit))
  ci <- exp(confint(fit))
  data.frame(
    term = names(hr),
    HR = as.numeric(hr),
    CI_low = ci[, 1],
    CI_high = ci[, 2],
    p = s$coefficients[, "Pr(>|z|)"],
    row.names = NULL
  )
}

plot_km <- function(res, extra = "") {
  ggsurvplot(
    res$km_fit, data = res$data,
    pval = TRUE, risk.table = TRUE, conf.int = FALSE,
    ggtheme = theme_minimal(),
    title = paste0(res$gene, " | ", res$method, " | n=", res$n, " ", extra)
  )
}

# ---------------------------
# 5) Example
# ---------------------------
# --- Full KM plot code (maxstat) that SAVES PNG + writes cutoff table CSV ---
# Assumes you already have:
#   - expr: log2(TPM+1) matrix (genes x samples)
#   - surv_df: survival dataframe with OS_time, OS_event, sample, etc.
#   - run_gene_survival(), print_hr() defined as in your pipeline
#   - GENE set (e.g., "KRAS")

GENE <- "KRAS"  # change

# 1) Run maxstat
res <- run_gene_survival(GENE, method = "maxstat", minprop = 0.25)



# Run maxstat survival first
GENE <- "KRAS"
res <- run_gene_survival(GENE, method = "maxstat", minprop = 0.25)

# Create KM plot (keep your existing styling)
g <- survminer::ggsurvplot(
  res$km_fit,
  data = res$data,
  palette = c("#E7B800", "#2E9FDF"),  # default survminer colors
  pval = TRUE,
  risk.table = TRUE,
  conf.int = FALSE,
  risk.table.col = "strata",
  ggtheme = theme_classic(base_size = 14),
  xlab = "Time (days)",
  ylab = "Overall survival probability",
  legend.title = "",
  legend.labs = c("Low", "High")
)

# Save high-resolution PNG
png(
  filename = "KRAS_KM_maxstat.png",
  width = 2400,   # pixels
  height = 2000,  # pixels
  res = 400       # 300–600 dpi is publication standard
)

print(g)
dev.off()

cat("Saved high-resolution plot: KRAS_KM_maxstat.png\n")


# 2) Extract cutoff on log2(TPM+1) scale + summary stats
# Publication-quality export (PNG only) + cutoff/HR CSV
# Keeps your logic; only upgrades plot theme + resolution.

# ---- run maxstat first ----
# GENE <- "KRAS"
# res <- run_gene_survival(GENE, method = "maxstat", minprop = 0.25)

# 2) Extract cutoff on log2(TPM+1) scale + summary stats
cut_log2 <- as.numeric(res$cutoff)
group_counts <- table(res$data$group)
n_low  <- as.numeric(group_counts["Low"])
n_high <- as.numeric(group_counts["High"])

hr_table <- print_hr(res$cox_unadj)
hr_group <- hr_table[grep("^group", hr_table$term), , drop = FALSE]

# 3) Save statistical table (CSV) with cutoff value
summary_df <- data.frame(
  Gene = GENE,
  Cutoff_log2_TPM_plus1 = cut_log2,
  N_Low = n_low,
  N_High = n_high,
  HR_High_vs_Low = hr_group$HR %||% NA_real_,
  CI_lower = hr_group$CI_low %||% NA_real_,
  CI_upper = hr_group$CI_high %||% NA_real_,
  p_value = hr_group$p %||% NA_real_,
  stringsAsFactors = FALSE
)

csv_out <- paste0(GENE, "_maxstat_summary.csv")
write.csv(summary_df, csv_out, row.names = FALSE)
cat("Saved:", csv_out, "\n")

# 4) Create KM plot (ggsurvplot object) - publication theme + default survminer palette
title_txt <- paste0(
  GENE,
  " (Maxstat cutoff = ",
  round(cut_log2, 4),
  ")"
)


g <- survminer::ggsurvplot(
  fit = res$km_fit,
  data = res$data,
  palette = c("#E7B800", "#2E9FDF"),   # survminer default colors
  pval = TRUE,
  risk.table = TRUE,
  risk.table.col = "strata",           # risk table labels match curve colors
  conf.int = FALSE,
  ggtheme = ggplot2::theme_classic(base_size = 14),
  title = title_txt,
  xlab = "Time (days)",
  ylab = "Overall survival probability",
  legend.title = "Group",
  legend.labs = c("Low", "High")
)

# 5) Save to high-resolution PNG (includes risk table)
# Choose ONE of these:
# - 300 dpi: res=300 (standard)
# - 400 dpi: res=400 (very safe)
# - 600 dpi: res=600 (some journals request)
png_out <- paste0(GENE, "_KM_maxstat.png")

png(filename = png_out, width = 2400, height = 2000, res = 400)  # publication-quality
print(g)
dev.off()

cat("Saved:", png_out, "\n")
cat("Working directory:", getwd(), "\n")
######################## Natural style ######
# ---------------------------------------------------------
# Nature-style monochrome KM plot
# ---------------------------------------------------------

g_nature <- survminer::ggsurvplot(
  fit = res$km_fit,
  data = res$data,
  palette = c("black", "grey50"),   # monochrome
  linetype = c("solid", "dashed"),  # distinguish groups
  pval = TRUE,
  risk.table = TRUE,
  risk.table.col = "black",         # risk table in black
  conf.int = FALSE,
  ggtheme = theme_classic(base_size = 14),
  title = title_txt,
  xlab = "Time (days)",
  ylab = "Overall survival probability",
  legend.title = "",
  legend.labs = c("Low", "High")
)

# Make lines thicker (Nature prefers slightly thicker curves)
g_nature$plot <- g_nature$plot +
  theme(
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.8),
    axis.line = element_line(linewidth = 0.8),
    axis.ticks = element_line(linewidth = 0.8),
    legend.position = c(0.8, 0.85)
  ) +
  guides(color = guide_legend(override.aes = list(linewidth = 1.5)))

g_nature$table <- g_nature$table +
  theme_classic(base_size = 11) +
  theme(
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.6)
  )

# Save high-resolution Nature-style PNG
png(
  filename = paste0(GENE, "_KM_maxstat_nature.png"),
  width = 2400, 
  height = 2000, res = 400
  #res = 600   # Nature-quality resolution
)

print(g_nature)
dev.off()

cat("Saved Nature-style plot:",
    paste0(GENE, "_KM_maxstat_nature.png"), "\n")

# ==========================================================
# FULL plotting code (publication-quality, Nature-style monochrome)
# Fixes legend overlap by placing legend OUTSIDE (right).
# Saves: KRAS_KM_maxstat_nature.png (high-res)
# Assumes:
#   res <- run_gene_survival(GENE, method="maxstat", ...)
# ==========================================================

suppressPackageStartupMessages({
  library(survival)
  library(survminer)
  library(ggplot2)
})

GENE <- "KRAS"
res  <- run_gene_survival(GENE, method = "maxstat", minprop = 0.25)

cut_log2 <- as.numeric(res$cutoff)

title_txt <- paste0(
  GENE,
  " (Maxstat cutoff = ",
  round(cut_log2, 4),
  ")"
)

# Nature-style monochrome palette + linetypes
km_palette <- c("black", "grey50")
km_lty     <- c("solid", "dashed")

# ---- Plot styling (border, axes, legend outside) ----
g_nature$plot <- g_nature$plot +
  theme(
    panel.border = element_rect(color = "black", fill = NA, linewidth = 1.0),
    axis.line = element_line(linewidth = 0.9),
    axis.ticks = element_line(linewidth = 0.9),
    plot.title = element_text(face = "bold", size = 16, hjust = 0),
    axis.title = element_text(size = 22),
    axis.text = element_text(size = 18),
    legend.position = "right",          # KEY FIX: no overlap with border
    legend.text = element_text(size = 18),
    legend.key = element_blank(),
    legend.background = element_blank()
  )

# ---- Risk table styling (keep clean, readable) ----
g_nature$table <- g_nature$table +
  theme_classic(base_size = 16) +
  theme(
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.9),
    axis.text.x = element_text(size = 16),
    axis.text.y = element_text(size = 16)
  )

# ---- Save high-resolution PNG (publication) ----
png_out <- paste0(GENE, "_KM_maxstat_nature.png")
png(filename = png_out, width = 7, height = 6, units = "in", res = 600)  # 600 dpi line art standard
print(g_nature)
dev.off()

cat("Saved:", png_out, "\nWorking directory:", getwd(), "\n")
###############################  GSVA score
# ----------------------------------------------------------
# Compute a single gene-set score (GSVA/ssGSEA) for each sample
# expr: matrix genes x samples (already log2(TPM+1))
# genes: character vector of gene symbols
# method: "ssgsea" (recommended for one signature) or "gsva"
# returns: numeric vector, named by sample
# ----------------------------------------------------------
# Bioconductor: GSVA
if (!requireNamespace("BiocManager", quietly = TRUE)) install.packages("BiocManager")
if (!requireNamespace("GSVA", quietly = TRUE)) BiocManager::install("GSVA")
library(GSVA)

# ----------------------------------------------------------
# Compute GSVA enrichment score for a single gene set
# - Uses method="gsva" (Hänzelmann et al., 2013)
# - expr: genes x samples matrix (recommended: log2(TPM+1))
# - returns numeric vector named by sample
# ----------------------------------------------------------
# ----------------------------------------------------------
# GSVA score for one gene set (Hänzelmann et al. 2013), compatible with:
# - old GSVA API (gsva(expr, gset.idx.list, ...))
# - new GSVA API (gsva(param_object))
# expr: genes x samples matrix (log2(TPM+1) is fine)
# ----------------------------------------------------------
gsva_score_one <- function(expr, genes, set_name = "MySignature",
                           min_genes = 5, kcdf = "Gaussian") {
  
  genes <- unique(genes)
  genes_in <- intersect(genes, rownames(expr))
  if (length(genes_in) < min_genes) {
    stop(sprintf("Too few genes found in expr for %s: %d (need >= %d).",
                 set_name, length(genes_in), min_genes))
  }
  
  gset <- list()
  gset[[set_name]] <- genes_in
  
  # NEW GSVA API uses a 'param' object; old API uses (expr, gset.idx.list, ...)
  gsva_formals <- names(formals(GSVA::gsva))
  
  if ("param" %in% gsva_formals) {
    # ---- New API ----
    # Some versions use gsvaParam(), others use GSVAParams()/gsvaParam method names
    if (exists("gsvaParam", where = asNamespace("GSVA"), inherits = FALSE)) {
      param <- GSVA::gsvaParam(expr = as.matrix(expr), geneSets = gset, kcdf = kcdf)
      score_mat <- GSVA::gsva(param, verbose = FALSE)
    } else {
      stop("Your GSVA version expects a param object, but gsvaParam() was not found. Please update GSVA.")
    }
  } else {
    # ---- Old API ----
    score_mat <- GSVA::gsva(
      expr = as.matrix(expr),
      gset.idx.list = gset,
      method = "gsva",     # default GSVA method (Hänzelmann et al. 2013)
      kcdf = kcdf,
      verbose = FALSE
    )
  }
  
  scores <- as.numeric(score_mat[1, ])
  names(scores) <- colnames(expr)
  scores
}

# ----------------------------------------------------------
# Survival using any numeric feature (e.g., GSVA score)
# Supports: median / quantile / maxstat stratification
# Robust Cox fitting:
# - increases iter.max to reduce non-convergence
# - skips adjusted Cox if too few events
# - drops covariates that are all-NA or constant after filtering
# ----------------------------------------------------------
run_feature_survival <- function(feature_vec, feature_name = "feature",
                                 method = c("median", "quantile", "maxstat"),
                                 q = c(0.25, 0.75),
                                 minprop = 0.25,
                                 adjust_covars = DEFAULT_COVARS,
                                 min_events_for_adj = 10,
                                 cox_iter_max = 100,
                                 cox_eps = 1e-9) {
  
  method <- match.arg(method)
  
  # Build analysis data
  dat <- surv_df %>%
    mutate(feature = as.numeric(feature_vec[sample])) %>%
    filter(!is.na(feature))
  
  if (nrow(dat) < 10) stop("Too few samples after filtering non-NA feature values.")
  
  cutoff <- NA
  
  # Stratify
  if (method == "median") {
    cutoff <- median(dat$feature, na.rm = TRUE)
    dat <- dat %>% mutate(group = ifelse(feature > cutoff, "High", "Low"))
    
  } else if (method == "quantile") {
    qs <- quantile(dat$feature, probs = q, na.rm = TRUE)
    cutoff <- qs
    dat <- dat %>%
      mutate(group = case_when(
        feature <= qs[1] ~ "Low",
        feature >= qs[2] ~ "High",
        TRUE ~ NA_character_
      )) %>%
      filter(!is.na(group))
    
  } else { # maxstat
    ms <- maxstat::maxstat.test(
      survival::Surv(OS_time, OS_event) ~ feature,
      data = dat,
      smethod = "LogRank",
      pmethod = "exactGauss",
      minprop = minprop
    )
    cutoff <- as.numeric(ms$estimate)
    dat <- dat %>% mutate(group = ifelse(feature > cutoff, "High", "Low"))
  }
  
  dat$group <- factor(dat$group, levels = c("Low", "High"))
  
  # Basic sanity checks
  if (length(unique(dat$group)) < 2) stop("Only one group present after stratification.")
  if (sum(dat$OS_event == 1, na.rm = TRUE) < 1) stop("No events present after stratification.")
  
  # KM
  km_fit <- survival::survfit(survival::Surv(OS_time, OS_event) ~ group, data = dat)
  
  # Cox controls (helps convergence)
  cox_ctrl <- survival::coxph.control(iter.max = cox_iter_max, eps = cox_eps)
  
  # Cox unadjusted
  cox_unadj <- survival::coxph(
    survival::Surv(OS_time, OS_event) ~ group,
    data = dat,
    control = cox_ctrl
  )
  
  # Cox adjusted (skip if too few events)
  n_events <- sum(dat$OS_event == 1, na.rm = TRUE)
  covars_used <- prep_covars(dat, adjust_covars)
  
  cox_adj <- NULL
  if (length(covars_used) > 0 && n_events >= min_events_for_adj) {
    fml <- as.formula(
      paste0("survival::Surv(OS_time, OS_event) ~ group + ", paste(covars_used, collapse = " + "))
    )
    cox_adj <- survival::coxph(fml, data = dat, control = cox_ctrl)
  } else {
    message(sprintf(
      "Adjusted Cox skipped for %s (%s): covars=%d, events=%d (<%d).",
      feature_name, method, length(covars_used), n_events, min_events_for_adj
    ))
  }
  
  list(
    feature_name = feature_name,
    method = method,
    cutoff = cutoff,
    n = nrow(dat),
    n_events = n_events,
    data = dat,
    km_fit = km_fit,
    cox_unadj = cox_unadj,
    cox_adj = cox_adj,
    covars_used = covars_used
  )
}

# Example gene list (replace with your signature)
sig_genes <- c("KRAS", "EGFR", "MAPK1", "MAPK3", "PIK3CA", "AKT1")

# 1) GSVA enrichment score (default GSVA method)
sig_score <- gsva_score_one(expr, sig_genes, set_name = "MySignature", min_genes = 5)

# Optional: add to surv_df
surv_df$MySignature_GSVA <- sig_score[surv_df$sample]

# 2A) Quantile (Q1 vs Q4)
res_q <- run_feature_survival(sig_score, feature_name = "MySignature_GSVA",
                              method = "quantile", q = c(0.25, 0.75))

# 2B) Maxstat
res_m <- run_feature_survival(sig_score, feature_name = "MySignature_GSVA",
                              method = "maxstat", minprop = 0.25)

# 3) Plot quickly
print(ggsurvplot(res_q$km_fit, data = res_q$data, pval = TRUE, risk.table = TRUE, conf.int = FALSE))
print(ggsurvplot(res_m$km_fit, data = res_m$data, pval = TRUE, risk.table = TRUE, conf.int = FALSE))


###################### new function ##########################
run_feature_survival <- function(feature_vec, feature_name = "feature",
                                 method = c("median", "quantile", "maxstat"),
                                 q = c(0.25, 0.75),
                                 minprop = 0.25,
                                 adjust_covars = DEFAULT_COVARS,
                                 min_events_for_adj = 10,
                                 cox_iter_max = 100,
                                 cox_eps = 1e-9,
                                 save_plot = TRUE,
                                 plot_width_in = 7,
                                 plot_height_in = 6,
                                 plot_dpi = 600) {
  
  method <- match.arg(method)
  
  dat <- surv_df %>%
    mutate(feature = as.numeric(feature_vec[sample])) %>%
    filter(!is.na(feature))
  
  if (nrow(dat) < 10) stop("Too few samples after filtering non-NA feature values.")
  
  cutoff <- NA
  
  if (method == "median") {
    cutoff <- median(dat$feature, na.rm = TRUE)
    dat <- dat %>% mutate(group = ifelse(feature > cutoff, "High", "Low"))
    
  } else if (method == "quantile") {
    qs <- quantile(dat$feature, probs = q, na.rm = TRUE)
    cutoff <- qs
    dat <- dat %>%
      mutate(group = case_when(
        feature <= qs[1] ~ "Low",
        feature >= qs[2] ~ "High",
        TRUE ~ NA_character_
      )) %>%
      filter(!is.na(group))
    
  } else {  # maxstat
    ms <- maxstat::maxstat.test(
      survival::Surv(OS_time, OS_event) ~ feature,
      data = dat,
      smethod = "LogRank",
      pmethod = "exactGauss",
      minprop = minprop
    )
    cutoff <- as.numeric(ms$estimate)
    dat <- dat %>% mutate(group = ifelse(feature > cutoff, "High", "Low"))
  }
  
  dat$group <- factor(dat$group, levels = c("Low", "High"))
  
  if (length(unique(dat$group)) < 2) stop("Only one group present after stratification.")
  if (sum(dat$OS_event == 1, na.rm = TRUE) < 1) stop("No events present after stratification.")
  
  # KM
  km_fit <- survival::survfit(survival::Surv(OS_time, OS_event) ~ group, data = dat)
  
  # Cox
  cox_ctrl <- survival::coxph.control(iter.max = cox_iter_max, eps = cox_eps)
  
  cox_unadj <- survival::coxph(
    survival::Surv(OS_time, OS_event) ~ group,
    data = dat,
    control = cox_ctrl
  )
  
  n_events <- sum(dat$OS_event == 1, na.rm = TRUE)
  covars_used <- prep_covars(dat, adjust_covars)
  
  cox_adj <- NULL
  if (length(covars_used) > 0 && n_events >= min_events_for_adj) {
    fml <- as.formula(
      paste0("survival::Surv(OS_time, OS_event) ~ group + ",
             paste(covars_used, collapse = " + "))
    )
    cox_adj <- survival::coxph(fml, data = dat, control = cox_ctrl)
  }
  
  # ---------------------------
  # Save publication-quality KM plot
  # ---------------------------
  if (save_plot) {
    
    title_txt <- if (method == "maxstat") {
      paste0(feature_name, " (Maxstat cutoff = ", round(cutoff, 4), ")")
    } else if (method == "quantile") {
      paste0(feature_name, " (Q", q[1]*100, " vs Q", q[2]*100, ")")
    } else {
      paste0(feature_name, " (Median stratification)")
    }
    
    g <- survminer::ggsurvplot(
      km_fit,
      data = dat,
      palette = c("#E7B800", "#2E9FDF"),
      pval = TRUE,
      risk.table = TRUE,
      risk.table.col = "strata",
      conf.int = FALSE,
      ggtheme = ggplot2::theme_classic(base_size = 16),
      title = title_txt,
      xlab = "Time (days)",
      ylab = "Overall survival probability",
      legend.title = "",
      legend.labs = c("Low", "High")
    )
    
    file_name <- paste0(feature_name, "_", method, "_KM.png")
    
    png(filename = file_name,
        width = plot_width_in,
        height = plot_height_in,
        units = "in",
        res = plot_dpi)
    
    print(g)
    dev.off()
    
    cat("Saved KM plot:", file_name, "\n")
  }
  
  list(
    feature_name = feature_name,
    method = method,
    cutoff = cutoff,
    n = nrow(dat),
    n_events = n_events,
    data = dat,
    km_fit = km_fit,
    cox_unadj = cox_unadj,
    cox_adj = cox_adj,
    covars_used = covars_used
  )
}
res_q <- run_feature_survival(sig_score,
                              feature_name = "MySignature_GSVA",
                              method = "quantile",
                              q = c(0.25, 0.75))

res_m <- run_feature_survival(sig_score,
                              feature_name = "MySignature_GSVA",
                              method = "maxstat",
                              minprop = 0.25)



