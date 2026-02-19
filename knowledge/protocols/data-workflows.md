# Data Analysis Workflows

Practical workflows for analyzing multi-omic data to support indication selection decisions.

## Workflow 1: TCGA Immune Infiltration Analysis

**Objective:** Rank cancer types by target cell abundance

**Required data:**
- TCGA PanCancer immune estimates (Thorsson et al. Cell 2018)
- Available at: https://gdc.cancer.gov/about-data/publications/panimmune

**Steps:**

1. **Download immune feature matrix:**
   - `Thorsson_Scores_160_Signatures.tsv` - immune signature scores
   - `TCGA_PanImmune_Cell_Estimates.txt` - cell type estimates

2. **Load and process:**
```python
import pandas as pd
import numpy as np

# Load cell estimates
cells = pd.read_csv('TCGA_PanImmune_Cell_Estimates.txt', sep='\t')

# For each cancer type, calculate median abundance
cancer_types = cells['TCGA Study'].unique()

results = {}
for cancer in cancer_types:
    subset = cells[cells['TCGA Study'] == cancer]
    results[cancer] = {
        'CD8_T_cells': subset['CD8 T cells'].median(),
        'NK_cells': subset['NK cells'].median(),
        'Dendritic_cells': subset['Dendritic cells'].median(),
        'Leukocyte_fraction': subset['Leukocyte Fraction'].median(),
        'n_samples': len(subset)
    }

# Convert to DataFrame and rank
df = pd.DataFrame(results).T
df['rank_CD8'] = df['CD8_T_cells'].rank(ascending=False)
```

3. **Filter and prioritize:**
```python
# For IL-15 cytokine targeting CD8+ T cells:
threshold = 0.10  # 10% of leukocytes

candidates = df[df['CD8_T_cells'] > threshold].copy()
candidates = candidates.sort_values('CD8_T_cells', ascending=False)

print(f"Top 10 indications by CD8+ T cell abundance:")
print(candidates[['CD8_T_cells', 'Leukocyte_fraction']].head(10))
```

**Expected output:**
```
             CD8_T_cells  Leukocyte_fraction
SKCM         0.24         0.31
THYM         0.22         0.45
HNSC         0.18         0.29
CESC         0.17         0.28
BLCA         0.16         0.27
...
```

---

## Workflow 2: Immune Archetype Distribution Analysis

**Objective:** Determine immune subtype prevalence per indication

**Required data:**
- TCGA immune subtypes: `Subtype_Immune_Model_Based.txt`

**Steps:**

1. **Load subtype assignments:**
```python
subtypes = pd.read_csv('Subtype_Immune_Model_Based.txt', sep='\t')

# Map numeric codes to names
subtype_names = {
    'C1': 'Wound Healing',
    'C2': 'IFN-gamma Dominant',
    'C3': 'Inflammatory',
    'C4': 'Lymphocyte Depleted',
    'C5': 'Immunologically Quiet',
    'C6': 'TGF-beta Dominant'
}
```

2. **Calculate distribution per cancer type:**
```python
def get_archetype_distribution(cancer_type):
    subset = subtypes[subtypes['TCGA Study'] == cancer_type]
    dist = subset['Immune Subtype'].value_counts(normalize=True)
    return dist

# For all cancer types
archetype_matrix = pd.DataFrame()
for cancer in cancer_types:
    dist = get_archetype_distribution(cancer)
    archetype_matrix[cancer] = dist

archetype_matrix = archetype_matrix.fillna(0)  # Fill missing with 0
```

3. **Score compatibility with cytokine MOA:**
```python
# Example: IL-15 cytokine MOA compatibility scores
moa_compatibility = {
    'C1': 0.40,  # Wound healing - moderate
    'C2': 0.95,  # IFN-gamma - excellent
    'C3': 0.80,  # Inflammatory - good
    'C4': 0.15,  # Depleted - poor
    'C5': 0.10,  # Quiet - very poor
    'C6': 0.30   # TGF-beta - needs combo
}

# Calculate weighted score per indication
indication_scores = {}
for cancer in archetype_matrix.columns:
    score = sum(
        archetype_matrix.loc[subtype, cancer] * moa_compatibility[subtype]
        for subtype in archetype_matrix.index
    )
    indication_scores[cancer] = score

# Rank
scored_df = pd.DataFrame.from_dict(indication_scores, orient='index', 
                                    columns=['Archetype_Score'])
scored_df = scored_df.sort_values('Archetype_Score', ascending=False)
```

---

## Workflow 3: Single-Cell Cell State Analysis

**Objective:** Quantify T cell dysfunction states from scRNA-seq

**Required data:**
- Single-cell datasets from TISCH, Broad Portal, or published studies
- Cell type annotations

**Steps:**

1. **Load single-cell data (example using Scanpy):**
```python
import scanpy as sc

# Load annotated dataset
adata = sc.read_h5ad('tumor_scRNA_annotated.h5ad')

# Subset to CD8+ T cells
cd8 = adata[adata.obs['cell_type'] == 'CD8_T'].copy()
```

2. **Define gene signatures:**
```python
signatures = {
    'progenitor_exhausted': [
        'TCF7', 'LEF1', 'PDCD1', 'CD28', 'CXCR5'
    ],
    'terminal_exhausted': [
        'HAVCR2', 'LAG3', 'TIGIT', 'TOX', 'ENTPD1'
    ],
    'effector': [
        'GZMB', 'PRF1', 'IFNG', 'GNLY', 'NKG7'
    ],
    'early_dysfunction': [
        'PDCD1'  # PD-1+ but not multi-marker+
    ],
    'memory': [
        'IL7R', 'SELL', 'CCR7', 'TCF7'
    ]
}
```

3. **Score cells for each signature:**
```python
import scanpy.external as sce

for sig_name, genes in signatures.items():
    sc.tl.score_genes(cd8, gene_list=genes, 
                     score_name=f'{sig_name}_score')

# Classify cells by highest score
def classify_cell_state(row):
    scores = {
        'progenitor': row['progenitor_exhausted_score'],
        'terminal': row['terminal_exhausted_score'],
        'effector': row['effector_score'],
        'memory': row['memory_score']
    }
    return max(scores, key=scores.get)

cd8.obs['cell_state'] = cd8.obs.apply(classify_cell_state, axis=1)

# Calculate distribution
state_dist = cd8.obs['cell_state'].value_counts(normalize=True)
print(state_dist)
```

4. **Score compatibility:**
```python
# Example: IL-15 responsiveness by cell state
state_responsiveness = {
    'progenitor': 0.95,
    'memory': 0.90,
    'effector': 0.70,
    'early_dysfunction': 0.85,
    'terminal': 0.10
}

compatibility_score = sum(
    state_dist[state] * state_responsiveness[state]
    for state in state_dist.index
)

print(f"Cell state compatibility score: {compatibility_score:.2f}")
```

---

## Workflow 4: Pathway Activity Scoring (ssGSEA)

**Objective:** Quantify pathway activity from bulk RNA-seq

**Required data:**
- TCGA gene expression matrix (FPKM or TPM)
- MSigDB gene sets

**Steps:**

1. **Load expression data:**
```python
import gseapy as gp

# Load TCGA expression matrix for indication
expr = pd.read_csv('TCGA_LUAD_expression.txt', sep='\t', index_col=0)
```

2. **Download gene sets:**
```python
# Get Hallmark gene sets from MSigDB
gene_sets = gp.get_library('MSigDB_Hallmark_2020')

# Or define custom cytokine-relevant pathways
custom_sets = {
    'JAK_STAT_SIGNALING': ['JAK1', 'JAK3', 'STAT3', 'STAT5A', 'STAT5B', ...],
    'IFNG_RESPONSE': ['IFNG', 'CXCL9', 'CXCL10', 'IDO1', ...],
    'IL2_STAT5_SIGNALING': ['IL2RA', 'IL2RB', 'IL2RG', 'STAT5A', 'STAT5B', ...]
}
```

3. **Run ssGSEA:**
```python
# Single-sample GSEA
ss = gp.ssgsea(data=expr,
               gene_sets=gene_sets,
               outdir=None,  # Don't save
               sample_norm_method='rank',
               min_size=15,
               max_size=500)

# Extract enrichment scores
pathway_scores = ss.res2d.pivot(index='Term', columns='Name', values='NES')
```

4. **Analyze pathway activity:**
```python
# Calculate median pathway score across samples
median_scores = pathway_scores.median(axis=1)

# Relevant pathways for cytokine
cytokine_pathways = [
    'HALLMARK_IL2_STAT5_SIGNALING',
    'HALLMARK_INTERFERON_GAMMA_RESPONSE',
    'HALLMARK_INFLAMMATORY_RESPONSE',
    'HALLMARK_TNFA_SIGNALING_VIA_NFKB'
]

print("Pathway activity scores:")
for pathway in cytokine_pathways:
    if pathway in median_scores.index:
        print(f"{pathway}: {median_scores[pathway]:.2f}")
```

5. **Check for suppressors:**
```python
# Query expression of negative regulators
suppressors = ['SOCS1', 'SOCS3', 'PTPN6', 'PTPN11', 'PIAS1']

if all(s in expr.index for s in suppressors):
    suppressor_expr = expr.loc[suppressors].median(axis=1)
    print("\nSuppressor expression:")
    print(suppressor_expr)
```

---

## Workflow 5: Clinical Trial Data Extraction

**Objective:** Extract checkpoint inhibitor response rates by indication

**Data source:** ClinicalTrials.gov API, PubMed literature

**Steps:**

1. **Query ClinicalTrials.gov API:**
```python
import requests

def query_trials(condition, intervention):
    base_url = "https://clinicaltrials.gov/api/v2/studies"
    params = {
        'query.cond': condition,
        'query.intr': intervention,
        'filter.overall': 'phase:2,3',
        'pageSize': 100
    }
    response = requests.get(base_url, params=params)
    return response.json()

# Example: NSCLC + pembrolizumab
nsclc_trials = query_trials('NSCLC', 'pembrolizumab')
```

2. **Parse trial results (if posted):**
```python
def extract_orr(trial_json):
    # Extract ORR from results if available
    # (Structure depends on how results are posted)
    try:
        results = trial_json.get('resultsSection', {})
        outcome_measures = results.get('outcomeList', {}).get('outcome', [])
        
        for outcome in outcome_measures:
            if 'response' in outcome.get('title', '').lower():
                # Extract ORR value
                # This is simplified - actual parsing more complex
                return outcome.get('value')
    except:
        return None
```

3. **Supplement with PubMed literature:**
```python
from Bio import Entrez

Entrez.email = "your_email@example.com"

def search_pubmed(query):
    handle = Entrez.esearch(db="pubmed", term=query, retmax=50)
    record = Entrez.read(handle)
    return record["IdList"]

# Example query
query = "pembrolizumab NSCLC response rate phase 2"
pmids = search_pubmed(query)

# Fetch abstracts and extract data (manual or NLP)
```

4. **Compile benchmark table:**
```python
# Create summary table
benchmarks = pd.DataFrame({
    'Indication': ['Melanoma', 'NSCLC', 'RCC', 'TNBC', ...],
    'Anti-PD1_ORR': [0.40, 0.20, 0.25, 0.10, ...],
    'Combo_ORR': [0.58, 0.36, 0.42, None, ...],
    'Number_Trials': [50, 120, 35, 15, ...]
})
```

---

## Workflow 6: Integrated Scoring Pipeline

**Objective:** Combine all analyses into final indication ranking

**Steps:**

1. **Compile scores from all workflows:**
```python
# Biological scores
bio_scores = pd.DataFrame({
    'target_cell_abundance': df['CD8_T_cells'],  # From Workflow 1
    'archetype_fit': scored_df['Archetype_Score'],  # From Workflow 2
    'pathway_activity': pathway_feasibility,  # From Workflow 4
})

# Clinical scores
clin_scores = pd.DataFrame({
    'checkpoint_response': benchmarks['Anti-PD1_ORR'],
    'trial_competition': 1 / (benchmarks['Number_Trials'] / 10 + 1)
})

# Commercial scores (from RWD or literature)
comm_scores = pd.DataFrame({
    'addressable_pop': normalize(incidence_data),
    'unmet_need': unmet_need_scores
})
```

2. **Normalize all scores 0-1:**
```python
def normalize(series, min_val=None, max_val=None):
    if min_val is None:
        min_val = series.min()
    if max_val is None:
        max_val = series.max()
    return (series - min_val) / (max_val - min_val)

# Normalize each component
for col in bio_scores.columns:
    bio_scores[col] = normalize(bio_scores[col])

# Similarly for clinical and commercial
```

3. **Calculate composite scores:**
```python
# Biological composite
bio_scores['biological'] = (
    0.30 * bio_scores['target_cell_abundance'] +
    0.25 * bio_scores['archetype_fit'] +
    0.20 * bio_scores['pathway_activity'] +
    0.25 * cell_state_compatibility  # From Workflow 3
)

# Clinical composite
clin_scores['clinical'] = (
    0.35 * clin_scores['checkpoint_response'] +
    0.20 * enrollment_feasibility +
    0.20 * biomarker_feasibility +
    0.25 * regulatory_clarity
)

# Commercial composite
comm_scores['commercial'] = (
    0.35 * comm_scores['addressable_pop'] +
    0.30 * comm_scores['unmet_need'] +
    0.20 * (1 - competition_intensity) +
    0.15 * market_value
)
```

4. **Final weighted score:**
```python
final_scores = pd.DataFrame({
    'biological': bio_scores['biological'],
    'clinical': clin_scores['clinical'],
    'commercial': comm_scores['commercial']
})

final_scores['total'] = (
    0.40 * final_scores['biological'] +
    0.35 * final_scores['clinical'] +
    0.25 * final_scores['commercial']
)

# Rank and export
final_scores['rank'] = final_scores['total'].rank(ascending=False)
final_scores = final_scores.sort_values('rank')

print(final_scores)
```

---

## Common Data Sources Quick Reference

| Data Type | Source | URL | Key Files |
|-----------|--------|-----|-----------|
| TCGA Immune | GDC Portal | portal.gdc.cancer.gov | Thorsson immune features |
| Single-cell | TISCH | tisch.comp-genomics.org | Pre-processed h5ad |
| Gene Sets | MSigDB | gsea-msigdb.org | Hallmark, KEGG, Reactome |
| Clinical Trials | CT.gov | clinicaltrials.gov/api | API v2 |
| Literature | PubMed | ncbi.nlm.nih.gov/pubmed | E-utilities API |
| Epidemiology | SEER | seer.cancer.gov | Cancer statistics |

---

## Workflow Best Practices

1. **Version control:** Record data versions (TCGA release, MSigDB version)
2. **Sample size:** Require n>50 for robust statistics
3. **Batch effects:** Check for and adjust batch effects in TCGA data
4. **Missing data:** Handle NAs appropriately (median imputation, exclusion)
5. **Validation:** Cross-validate findings across multiple datasets when possible
6. **Documentation:** Keep detailed analysis log with all parameters
