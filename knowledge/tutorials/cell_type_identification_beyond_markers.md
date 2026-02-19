# Cell Type Identification Beyond Predefined Marker Lists

## The Challenge

**Problem**: Gene lists from studies may contain genes not explicitly listed in skill marker databases, yet these genes can still indicate specific cell types through:
1. Pathway/functional associations
2. Gene Ontology annotations
3. Literature-based evidence
4. Expression database patterns
5. Co-expression networks

**Solution**: Multi-method approach combining computational tools, databases, and reasoning strategies.

---

## Method 1: Enrichment-Based Cell Type Inference

### Concept
Instead of relying on individual marker genes, use **gene set enrichment** against cell-type-specific gene expression databases.

### Databases for Cell Type Enrichment

**1. Human Gene Atlas / Mouse Gene Atlas**
- Tissue/cell line expression profiles
- Available via Enrichr, GSEA
- Example: Gene list enriched in "CD8+ T cells" or "Fibroblasts"

**2. ARCHS4 Tissues / ARCHS4 Cell Lines**
- Massive expression compendium
- Cell-type and tissue-specific signatures
- Available via Enrichr

**3. Tabula Sapiens / Tabula Muris**
- Single-cell RNA-seq atlases
- Cell-type-specific gene sets from healthy tissues
- Comprehensive cell type coverage

**4. Human Protein Atlas**
- Cell-type-specific protein expression
- RNA expression across cell types
- Can query genes individually

**5. PanglaoDB**
- Single-cell marker database
- Cell type marker genes across species
- Web interface and downloadable

**6. CellMarker 2.0**
- Curated cell markers from literature
- Tissue and cell type specific
- Covers normal and cancer cells

**7. Azimuth Reference Atlases**
- PBMC reference (immune cells)
- Lung, kidney, motor cortex, etc.
- Can map gene signatures to reference

### Implementation Strategy

```python
def infer_cell_type_by_enrichment(gene_list):
    """
    Use enrichment against cell type databases to infer cell identity.
    """
    import gseapy as gp
    
    # Multiple cell type databases
    cell_type_libraries = [
        'Human_Gene_Atlas',           # Broad tissue/cell types
        'ARCHS4_Tissues',             # Expression-based
        'Tabula_Sapiens',             # Single-cell based
        'ARCHS4_Cell-lines',          # Cell line expression
        'Jensen_TISSUES'              # Text-mining based
    ]
    
    results = {}
    for library in cell_type_libraries:
        try:
            enr = gp.enrichr(
                gene_list=gene_list,
                gene_sets=library,
                organism='human',
                outdir=None
            )
            results[library] = enr.results.head(5)
        except:
            continue
    
    # Consensus across databases
    return identify_consensus_cell_type(results)
```

**Advantages:**
- Works with ANY genes, not just known markers
- Statistical significance (p-values)
- Considers entire gene expression pattern
- Multiple databases provide validation

**Example:**
```
Gene list: [CTHRC1, WNT5A, IL13]
↓
Enrichr → Human_Gene_Atlas
↓
Results:
1. Fibroblasts (p = 1e-3) - CTHRC1 enriched
2. Macrophages (p = 5e-3) - WNT5A enriched  
3. Th2 cells (p = 1e-2) - IL13 enriched
↓
Interpretation: Mixed TME signature
```

---

## Method 2: Gene Ontology (GO) and Functional Annotation

### Concept
Use GO terms, KEGG pathways, and functional annotations to infer biological processes, then map processes to cell types.

### Strategy

**Step 1: Functional Enrichment**
```python
def functional_to_cell_type(gene_list):
    """
    Map GO terms and pathways to cell types.
    """
    # Get GO enrichment
    go_results = run_go_enrichment(gene_list, ['GO_Biological_Process_2023'])
    
    # Map GO terms to cell types
    go_to_cell_type = {
        'T cell activation': 'T cells',
        'B cell proliferation': 'B cells',
        'natural killer cell mediated cytotoxicity': 'NK cells',
        'macrophage activation': 'Macrophages',
        'collagen fibril organization': 'Fibroblasts',
        'angiogenesis': 'Endothelial cells',
        'antigen processing and presentation': 'APCs (DCs, macrophages)',
        'mast cell activation': 'Mast cells',
        'neutrophil chemotaxis': 'Neutrophils',
        'type 2 immune response': 'Th2 cells, eosinophils',
        # ... many more mappings
    }
    
    # Infer cell types from enriched processes
    cell_types = []
    for go_term in go_results['Term']:
        for pattern, cell_type in go_to_cell_type.items():
            if pattern.lower() in go_term.lower():
                cell_types.append(cell_type)
    
    return cell_types
```

**Example Mappings:**

| GO Term / Process | Likely Cell Type |
|-------------------|------------------|
| T cell activation | T cells |
| Regulation of cytokine production | Immune cells (broad) |
| Extracellular matrix organization | Fibroblasts, CAFs |
| Angiogenesis | Endothelial cells |
| Phagocytosis | Macrophages, neutrophils |
| Antigen presentation | DCs, macrophages, B cells |
| NK cell cytotoxicity | NK cells |
| Immunoglobulin production | Plasma cells |
| Mast cell degranulation | Mast cells |
| Epithelial cell proliferation | Epithelial cells |
| Wound healing | Fibroblasts, macrophages |

**Step 2: Pathway-to-Cell-Type Mapping**

| KEGG Pathway | Likely Cell Type |
|--------------|------------------|
| T cell receptor signaling | T cells |
| B cell receptor signaling | B cells |
| NK cell mediated cytotoxicity | NK cells |
| Fc gamma R-mediated phagocytosis | Macrophages, neutrophils |
| Antigen processing and presentation | APCs |
| ECM-receptor interaction | Fibroblasts, CAFs |
| Focal adhesion | Fibroblasts, CAFs |
| VEGF signaling pathway | Endothelial cells |
| Tight junction | Epithelial cells |

---

## Method 3: Literature Mining and Database Queries

### Concept
For genes not in predefined lists, query literature and expression databases to find cell-type associations.

### Tools and Approaches

**1. PubMed / PubTator Central**
- Search: "[GENE] AND cell type"
- Search: "[GENE] AND expression"
- Look for phrases like "specifically expressed in" or "marker of"

**2. GeneCards**
- Comprehensive gene information
- Expression section shows tissue/cell type
- Links to Human Protein Atlas

**3. Human Protein Atlas**
- RNA expression by cell type (single-cell data)
- Protein expression by tissue
- Web interface: https://www.proteinatlas.org/
- API available for batch queries

**4. GTEx Portal**
- Tissue-specific expression
- Can infer cell type from tissue enrichment
- Web: https://gtexportal.org/

**5. Expression Atlas (EBI)**
- Baseline and differential expression
- Cell type and tissue specific
- https://www.ebi.ac.uk/gxa/

### Implementation

```python
def query_expression_databases(gene):
    """
    Query multiple databases for cell-type expression.
    """
    results = {}
    
    # Human Protein Atlas (if API available)
    hpa_data = query_hpa(gene)
    results['HPA'] = {
        'cell_types': extract_cell_types_from_hpa(hpa_data),
        'tissues': extract_tissues_from_hpa(hpa_data)
    }
    
    # GTEx
    gtex_data = query_gtex(gene)
    results['GTEx'] = {
        'top_tissues': get_top_expressed_tissues(gtex_data)
    }
    
    # Expression Atlas
    atlas_data = query_expression_atlas(gene)
    results['Expression_Atlas'] = {
        'cell_types': extract_cell_types(atlas_data)
    }
    
    return results

def infer_from_literature(gene):
    """
    Mine PubMed abstracts for cell type associations.
    """
    # Search PubMed
    query = f"{gene} AND (cell type OR expression OR marker)"
    abstracts = search_pubmed(query, max_results=20)
    
    # Extract cell type mentions
    cell_type_keywords = [
        'T cell', 'B cell', 'macrophage', 'fibroblast', 
        'NK cell', 'dendritic cell', 'neutrophil',
        'endothelial', 'epithelial', 'cancer-associated fibroblast'
    ]
    
    mentions = {}
    for abstract in abstracts:
        for cell_type in cell_type_keywords:
            if cell_type.lower() in abstract.lower():
                mentions[cell_type] = mentions.get(cell_type, 0) + 1
    
    # Rank by frequency
    return sorted(mentions.items(), key=lambda x: x[1], reverse=True)
```

---

## Method 4: Gene Co-Expression Networks

### Concept
Genes expressed together in the same cell type will co-express across samples. Use co-expression to infer cell type.

### Approach

**1. STRING Database**
- Protein-protein interaction and co-expression
- Query gene → get co-expressed genes
- Check if co-expressed genes are known markers

**2. COXPRESdb**
- Co-expression database
- Find genes co-expressed with your query gene
- Infer cell type from co-expressed markers

**3. ARCHS4 / SEEK**
- Co-expression from massive datasets
- Find similarly expressed genes
- Infer cell type from pattern

### Implementation

```python
def infer_from_coexpression(gene, known_markers):
    """
    Find cell type by identifying co-expressed known markers.
    """
    # Get top co-expressed genes (from STRING, COXPRESdb, etc.)
    coexpressed_genes = get_coexpressed_genes(gene, top_n=50)
    
    # Check overlap with known markers
    cell_type_scores = {}
    for cell_type, markers in known_markers.items():
        overlap = set(coexpressed_genes) & set(markers)
        if len(overlap) > 0:
            cell_type_scores[cell_type] = len(overlap)
    
    # Rank by overlap
    return sorted(cell_type_scores.items(), key=lambda x: x[1], reverse=True)
```

**Example:**
```
Query: CTHRC1
↓
STRING co-expressed: POSTN, FN1, COL1A1, FAP, ACTA2
↓
Check against known markers:
- CAF markers: ACTA2, FAP, COL1A1 ✓✓✓
- Endothelial: VWF, PECAM1 ✗
↓
Inference: CTHRC1 likely CAF marker
```

---

## Method 5: Single-Cell RNA-seq Reference Mapping

### Concept
Use single-cell reference atlases to map gene expression patterns to cell types.

### Tools

**1. Azimuth**
- Web-based: https://azimuth.hubmapconsortium.org/
- References: PBMC, lung, kidney, motor cortex, etc.
- Input: Gene expression → Output: Cell type

**2. CellTypist**
- Python package
- Pre-trained models for multiple tissues
- Fast automated annotation

```python
import celltypist

# Load model
model = celltypist.models.Model.load(model='Immune_All_Low.pkl')

# Predict (requires expression matrix with genes as index)
predictions = celltypist.annotate(
    adata,  # AnnData object with your genes
    model=model,
    majority_voting=True
)
```

**3. SingleR (R package)**
- Reference-based annotation
- Uses correlation with reference profiles
- Multiple reference datasets available

```r
library(SingleR)

# Predict cell types
predictions <- SingleR(
    test = your_expression_data,
    ref = reference_data,
    labels = reference_data$cell_type
)
```

---

## Method 6: AI/LLM-Based Inference (When All Else Fails)

### Concept
Use Claude or other AI to reason about genes based on:
1. Gene name/symbol clues
2. Protein family membership
3. Known pathways
4. Biological knowledge

### Strategy

```
Prompt Template:

"Given the following genes: [GENE_LIST]

For each gene, determine:
1. What is the general function of this gene/protein?
2. Which cell types are likely to express this gene?
3. Is this gene a known marker for any cell type?
4. What biological processes involve this gene?

Use your knowledge of:
- Gene families (e.g., CD antigens, integrins, chemokines)
- Protein functions (e.g., transcription factors, surface receptors)
- Pathway participation
- Literature associations

Provide cell type inference with confidence level (high/medium/low)."
```

### Gene Name Clues

**Surface markers (CD antigens):**
- CD8A/CD8B → CD8+ T cells (high confidence)
- CD19, CD79A → B cells (high confidence)
- CD68, CD163 → Macrophages (high confidence)
- CD31 (PECAM1) → Endothelial (high confidence)

**Transcription factors:**
- FOXP3 → Regulatory T cells
- GATA3 → Th2 cells
- TBX21 (T-BET) → Th1 cells
- PAX5 → B cells
- PU.1 (SPI1) → Myeloid cells

**Chemokines/Cytokines:**
- CXCL9, CXCL10 → IFN-γ activated cells
- CCL18 → M2 macrophages
- IL13 → Th2 cells
- IFNG → Th1 cells, NK cells

**Structural proteins:**
- COL1A1, FN1 → Fibroblasts
- KRT (keratins) → Epithelial cells
- VIM (vimentin) → Mesenchymal cells

**Function-specific:**
- GZMB, PRF1 → Cytotoxic cells (CTL, NK)
- IGHG, JCHAIN → Plasma cells
- MKI67, TOP2A → Proliferating cells (any type)

---

## Integrated Multi-Method Workflow

### Step-by-Step Process

```python
def identify_cell_type_comprehensive(gene_list):
    """
    Comprehensive cell type identification using multiple methods.
    """
    results = {
        'methods': {},
        'consensus': None,
        'confidence': None
    }
    
    # Method 1: Check against known markers (fast)
    marker_result = check_known_markers(gene_list)
    results['methods']['markers'] = marker_result
    
    # Method 2: Enrichment analysis (high confidence)
    enrichment_result = enrichment_based_inference(gene_list)
    results['methods']['enrichment'] = enrichment_result
    
    # Method 3: GO/Pathway functional annotation
    functional_result = functional_annotation_inference(gene_list)
    results['methods']['functional'] = functional_result
    
    # Method 4: Expression database queries (for unknown genes)
    unknown_genes = identify_unknown_genes(gene_list, marker_result)
    if unknown_genes:
        expression_result = query_expression_databases_bulk(unknown_genes)
        results['methods']['expression_db'] = expression_result
    
    # Method 5: Co-expression analysis (if needed)
    if len(unknown_genes) > 0:
        coexpr_result = coexpression_inference(unknown_genes)
        results['methods']['coexpression'] = coexpr_result
    
    # Consensus building
    results['consensus'] = build_consensus(results['methods'])
    results['confidence'] = assess_confidence(results['methods'])
    
    return results


def build_consensus(method_results):
    """
    Build consensus cell type from multiple methods.
    """
    # Vote-based approach
    cell_type_votes = {}
    
    for method, result in method_results.items():
        if result and 'cell_type' in result:
            cell_types = result['cell_type']
            if isinstance(cell_types, str):
                cell_types = [cell_types]
            
            for ct in cell_types:
                cell_type_votes[ct] = cell_type_votes.get(ct, 0) + 1
    
    # Rank by votes
    ranked = sorted(cell_type_votes.items(), key=lambda x: x[1], reverse=True)
    
    # Return top consensus
    if ranked:
        return {
            'primary': ranked[0][0],
            'alternatives': [ct for ct, votes in ranked[1:3]],
            'votes': dict(ranked)
        }
    return None


def assess_confidence(method_results):
    """
    Assess confidence in cell type identification.
    """
    num_methods = len(method_results)
    num_concordant = count_concordant_methods(method_results)
    
    if num_concordant >= 3:
        return 'HIGH'
    elif num_concordant == 2:
        return 'MEDIUM'
    elif num_concordant == 1:
        return 'LOW'
    else:
        return 'UNCERTAIN'
```

---

## CRITICAL: Multi-Tissue Master Regulator Disambiguation

### The Problem

**Some master transcription factors create THE SAME transcriptional program in MULTIPLE tissues.**

This can cause framework to correctly identify the cellular program but incorrectly assign the tissue.

### Case Study: FOXI1 Paradox (Lesson Learned: Dec 31, 2025)

**FOXI1 drives identical programs in:**

| Tissue | Cell Type | Shared Markers | Unique Markers |
|--------|-----------|----------------|----------------|
| **Kidney** | Intercalated cells | FOXI1, ATP6V1B1, ATP6V1G3, BSND | SLC4A1/AE1, SLC26A4, CAII |
| **Lung** | Pulmonary ionocytes | FOXI1, ATP6V1B1, ATP6V1G3, BSND | **CFTR (extremely high!)** |
| **Inner Ear** | FORE cells | FOXI1, ATP6V1B1, ATP6V1G3, BSND | ATP6V0A4 |

**Real Example:**
- Gene list: `FOXI1, ATP6V1B1, ATP6V1G3, BSND, TFCP2L1, AQP6`
- Framework incorrectly identified: Kidney intercalated cells
- Correct answer: **Pulmonary ionocytes** (airway epithelium)
- Why wrong: Did not search multiple FOXI1 tissues, missed that CFTR discriminates

### Multi-Tissue Master Regulators - Watch List

**High-risk transcription factors that require tissue disambiguation:**

#### FOXI1
- **Tissues:** Kidney (ICs), Lung (ionocytes), Inner ear (endolymph), Epididymis
- **Discriminators:** 
  - CFTR (very high) → Lung ionocytes
  - SLC4A1/AE1 OR SLC26A4 → Kidney ICs
  - ATP6V0A4 → Inner ear

#### SOX2
- **Tissues:** Neural stem cells, Foregut endoderm, Tracheal epithelium, Retinal progenitors
- **Discriminators:** Context-specific co-factors (SOX1, SOX3 for neural; CDX2 for gut)

#### PAX6
- **Tissues:** Eye (lens, cornea, retina), Brain (neural progenitors), Pancreas (alpha cells)
- **Discriminators:**
  - SIX3, SIX6 → Eye development
  - PDX1, NKX6.1 → Pancreas
  - NEUROD1 → Retinal neurons

#### GATA3
- **Tissues:** T cells (Th2), Mammary gland, Kidney (nephric duct), Inner ear
- **Discriminators:**
  - CD3E, CD4, IL4 → T cells
  - KRT14, KRT18 → Mammary epithelium
  - LHX1, PAX2 → Kidney

#### FOXP3
- **Tissues:** Regulatory T cells, Some epithelial (controversial)
- **Discriminators:**
  - CD4, CD25, IL2RA, CTLA4 → Tregs
  - Without immune markers → Verify with literature

### Tissue Disambiguation Protocol

**MANDATORY when master TF with multi-tissue expression is identified:**

#### Step 1: Recognize Multi-Tissue TF

Check if identified transcription factor is known to operate in multiple tissues.

```python
MULTI_TISSUE_TFS = {
    'FOXI1': ['kidney', 'lung', 'inner_ear', 'epididymis'],
    'SOX2': ['neural', 'foregut', 'trachea', 'retina'],
    'PAX6': ['eye', 'brain', 'pancreas'],
    'GATA3': ['T_cells', 'mammary', 'kidney', 'inner_ear'],
    'FOXP3': ['T_cells', 'epithelial'],
    # Add more as discovered
}

def check_multitissue_tf(gene_list):
    """Check if gene list contains multi-tissue master TFs."""
    found_multitissue_tfs = []
    for gene in gene_list:
        if gene in MULTI_TISSUE_TFS:
            found_multitissue_tfs.append({
                'tf': gene,
                'tissues': MULTI_TISSUE_TFS[gene]
            })
    return found_multitissue_tfs
```

#### Step 2: Multi-Tissue Literature Search

**DO NOT only search one tissue!** Search ALL tissues where TF is expressed.

```python
def multitissue_literature_search(tf_name, core_genes):
    """
    Search literature for TF across all known tissues.
    """
    tissues = MULTI_TISSUE_TFS.get(tf_name, [])
    
    searches = []
    
    # Search each tissue specifically
    for tissue in tissues:
        query = f"{tf_name} {' '.join(core_genes[:3])} {tissue}"
        searches.append(query)
    
    # Broader searches
    searches.extend([
        f"{tf_name} all tissues expression",
        f"{tf_name} multiple cell types",
        f"{tf_name} {' '.join(core_genes[:5])} cell type"
    ])
    
    return searches
```

**Example for FOXI1 gene list:**
```
✅ Search 1: "FOXI1 ATP6V1B1 BSND kidney intercalated cells"
✅ Search 2: "FOXI1 ATP6V1B1 BSND lung airway ionocyte"
✅ Search 3: "FOXI1 ATP6V1B1 BSND inner ear"
✅ Search 4: "FOXI1 all tissues expression sites"
✅ Search 5: "FOXI1 cell types multiple"
```

#### Step 3: Build Tissue Discriminator Matrix

For each candidate tissue, identify which genes are **REQUIRED** vs **EXCLUDED**.

```python
TISSUE_DISCRIMINATORS = {
    'FOXI1': {
        'kidney_IC': {
            'required_any': ['SLC4A1', 'AE1', 'SLC26A4', 'CAII'],
            'excluded': ['CFTR_high'],  # CFTR rare/low in kidney
            'shared': ['ATP6V1B1', 'ATP6V1G3', 'BSND']
        },
        'lung_ionocyte': {
            'required_any': ['CFTR'],  # Extremely high!
            'excluded': ['SLC4A1', 'SLC26A4'],
            'shared': ['ATP6V1B1', 'ATP6V1G3', 'BSND']
        },
        'inner_ear': {
            'required_any': ['ATP6V0A4', 'SLC26A4'],
            'excluded': ['CFTR_high'],
            'shared': ['ATP6V1B1', 'ATP6V1G3', 'BSND']
        }
    }
}

def check_tissue_discriminators(gene_list, tf_name):
    """
    Check which tissue is most consistent with gene list.
    """
    if tf_name not in TISSUE_DISCRIMINATORS:
        return None
    
    tissue_scores = {}
    discriminators = TISSUE_DISCRIMINATORS[tf_name]
    
    for tissue, markers in discriminators.items():
        score = 0
        evidence = {'for': [], 'against': []}
        
        # Check required genes
        required = markers.get('required_any', [])
        has_required = any(gene in gene_list for gene in required)
        if has_required:
            score += 2
            evidence['for'].append(f"Has discriminator: {required}")
        
        # Check excluded genes (should NOT be present)
        excluded = markers.get('excluded', [])
        has_excluded = any(gene in gene_list for gene in excluded)
        if has_excluded:
            score -= 2
            evidence['against'].append(f"Has excluded marker: {excluded}")
        
        # Check shared genes
        shared = markers.get('shared', [])
        num_shared = sum(1 for gene in shared if gene in gene_list)
        score += num_shared * 0.5
        evidence['for'].append(f"Shared markers: {num_shared}/{len(shared)}")
        
        tissue_scores[tissue] = {
            'score': score,
            'evidence': evidence
        }
    
    return tissue_scores
```

#### Step 4: Missing Marker Analysis

**Check what's MISSING that should be present** for each candidate tissue.

```python
def analyze_missing_markers(gene_list, tf_name):
    """
    For each candidate tissue, check EXPECTED but MISSING markers.
    """
    if tf_name not in TISSUE_DISCRIMINATORS:
        return None
    
    missing_analysis = {}
    discriminators = TISSUE_DISCRIMINATORS[tf_name]
    
    for tissue, markers in discriminators.items():
        expected = markers.get('required_any', []) + markers.get('shared', [])
        missing = [gene for gene in expected if gene not in gene_list]
        
        missing_analysis[tissue] = {
            'expected_genes': expected,
            'missing_genes': missing,
            'percent_missing': len(missing) / len(expected) if expected else 0
        }
    
    return missing_analysis
```

**Example - FOXI1 gene list analysis:**

Gene list: `FOXI1, ATP6V1B1, ATP6V1G3, BSND, TFCP2L1`

```
Kidney IC:
  ✅ Has: ATP6V1B1, ATP6V1G3, BSND (shared)
  ❌ Missing: SLC4A1/AE1, SLC26A4, CAII (key discriminators!)
  📊 Missing: 3/7 expected genes (43%)

Lung Ionocyte:
  ✅ Has: ATP6V1B1, ATP6V1G3, BSND (shared)
  ❓ Missing: CFTR (but could be highest expresser, just not in list)
  📊 Missing: 1/4 expected genes (25%)

Conclusion: Lung ionocyte more likely (fewer missing expected markers)
```

#### Step 5: Build Tissue Confidence Matrix

Combine all evidence to assign confidence to each tissue.

```python
def build_tissue_confidence_matrix(
    gene_list, 
    tf_name, 
    literature_results,
    discriminator_scores,
    missing_analysis
):
    """
    Build comprehensive confidence assessment for each tissue.
    """
    tissues = MULTI_TISSUE_TFS.get(tf_name, [])
    confidence_matrix = {}
    
    for tissue in tissues:
        # Calculate composite score
        lit_score = literature_results.get(tissue, {}).get('relevance', 0)
        disc_score = discriminator_scores.get(tissue, {}).get('score', 0)
        missing_penalty = missing_analysis.get(tissue, {}).get('percent_missing', 0)
        
        composite = lit_score + disc_score - (missing_penalty * 2)
        
        # Assign confidence level
        if composite >= 3:
            confidence = 'HIGH'
        elif composite >= 1.5:
            confidence = 'MEDIUM-HIGH'
        elif composite >= 0:
            confidence = 'MEDIUM'
        else:
            confidence = 'LOW'
        
        confidence_matrix[tissue] = {
            'confidence': confidence,
            'composite_score': composite,
            'literature_score': lit_score,
            'discriminator_score': disc_score,
            'missing_penalty': missing_penalty
        }
    
    return confidence_matrix
```

#### Step 6: Report with Tissue Alternatives

**DO NOT report single tissue with VERY HIGH confidence if discriminators are missing!**

```python
def report_multitissue_results(
    tf_program,
    tissue_confidence_matrix,
    discriminators_present,
    discriminators_needed
):
    """
    Report cell type with appropriate tissue confidence.
    """
    # Sort tissues by confidence
    ranked_tissues = sorted(
        tissue_confidence_matrix.items(),
        key=lambda x: x[1]['composite_score'],
        reverse=True
    )
    
    top_tissue = ranked_tissues[0]
    alternatives = ranked_tissues[1:3]
    
    report = {
        'tf_program': tf_program,
        'program_confidence': 'VERY HIGH',  # We identified the TF program correctly
        'top_tissue': top_tissue[0],
        'tissue_confidence': top_tissue[1]['confidence'],
        'alternatives': [t[0] for t in alternatives if t[1]['composite_score'] > 0],
        'discriminators_present': discriminators_present,
        'discriminators_needed_to_confirm': discriminators_needed
    }
    
    return report
```

**Example output:**

```
CELL TYPE IDENTIFICATION RESULT:

Transcriptional Program: FOXI1+ Ion-Transporting Cell
Program Confidence: VERY HIGH (all methods concordant)

Most Likely Tissue: Pulmonary Ionocyte (Lung/Airway Epithelium)
Tissue Confidence: MEDIUM-HIGH

Evidence FOR lung ionocyte:
  ✅ All core genes present (FOXI1, V-ATPase, BSND)
  ✅ Literature confirms FOXI1 ionocytes in lung
  ✅ Fewer missing expected markers (1/4 missing)

Alternative Tissue: Kidney Intercalated Cell (Collecting Duct)
Tissue Confidence: MEDIUM

Evidence AGAINST kidney IC:
  ❌ Missing key discriminators: SLC4A1/AE1, SLC26A4, CAII
  ❌ These are expected in kidney ICs but absent

DISCRIMINATING GENES TO CONFIRM TISSUE:
  - CFTR (very high expression) → Confirms lung ionocyte
  - SLC4A1/AE1 OR SLC26A4 → Would indicate kidney IC
  - ATP6V0A4 + cochlear context → Would indicate inner ear

RECOMMENDATION:
  Search for CFTR in dataset. If CFTR is highly expressed, 
  confirms pulmonary ionocyte. If absent/low, reconsider kidney IC.
```

### Updated Comprehensive Workflow

The integrated workflow must now include tissue disambiguation:

```python
def identify_cell_type_comprehensive_v2(gene_list):
    """
    Comprehensive cell type identification with tissue disambiguation.
    """
    results = {
        'methods': {},
        'consensus': None,
        'confidence': None,
        'tissue_disambiguation': None
    }
    
    # Method 1: Check against known markers (fast)
    marker_result = check_known_markers(gene_list)
    results['methods']['markers'] = marker_result
    
    # NEW: Check for multi-tissue master TFs
    multitissue_tfs = check_multitissue_tf(gene_list)
    
    if multitissue_tfs:
        # TISSUE DISAMBIGUATION REQUIRED
        for tf_info in multitissue_tfs:
            tf_name = tf_info['tf']
            
            # Multi-tissue literature search
            lit_searches = multitissue_literature_search(tf_name, gene_list)
            lit_results = perform_literature_searches(lit_searches)
            
            # Check tissue discriminators
            disc_scores = check_tissue_discriminators(gene_list, tf_name)
            
            # Analyze missing markers
            missing = analyze_missing_markers(gene_list, tf_name)
            
            # Build confidence matrix
            tissue_confidence = build_tissue_confidence_matrix(
                gene_list, tf_name, lit_results, disc_scores, missing
            )
            
            results['tissue_disambiguation'] = {
                'tf': tf_name,
                'tissues': tf_info['tissues'],
                'confidence_matrix': tissue_confidence,
                'discriminators': disc_scores,
                'missing_analysis': missing
            }
    
    # Method 2: Enrichment analysis (high confidence)
    enrichment_result = enrichment_based_inference(gene_list)
    results['methods']['enrichment'] = enrichment_result
    
    # Method 3: GO/Pathway functional annotation
    functional_result = functional_annotation_inference(gene_list)
    results['methods']['functional'] = functional_result
    
    # Method 4: Expression database queries (for unknown genes)
    unknown_genes = identify_unknown_genes(gene_list, marker_result)
    if unknown_genes:
        expression_result = query_expression_databases_bulk(unknown_genes)
        results['methods']['expression_db'] = expression_result
    
    # Method 5: Co-expression analysis (if needed)
    if len(unknown_genes) > 0:
        coexpr_result = coexpression_inference(unknown_genes)
        results['methods']['coexpression'] = coexpr_result
    
    # Consensus building (now aware of tissue disambiguation)
    results['consensus'] = build_consensus_with_tissue_awareness(
        results['methods'],
        results.get('tissue_disambiguation')
    )
    
    results['confidence'] = assess_confidence_with_tissue_awareness(
        results['methods'],
        results.get('tissue_disambiguation')
    )
    
    return results
```

### Key Principles

1. **Recognize transcriptional programs accurately** (framework already does this well!)
2. **DO NOT assume single tissue** when master TF has multi-tissue expression
3. **Search ALL tissues** where master TF operates
4. **Use discriminating genes** to distinguish tissues
5. **Analyze missing markers** - what SHOULD be there but isn't?
6. **Report confidence appropriately:**
   - HIGH for transcriptional program
   - MEDIUM for tissue (if discriminators missing)
   - List alternatives and discriminators needed

### Success Metrics

**Before fix:**
- ❌ Reports: "Kidney IC, VERY HIGH confidence" (wrong tissue)

**After fix:**
- ✅ Reports: "FOXI1+ ion transporter, VERY HIGH confidence for program"
- ✅ Reports: "Most likely: Lung ionocyte (MEDIUM-HIGH)"
- ✅ Reports: "Alternative: Kidney IC (MEDIUM, but missing SLC4A1/SLC26A4)"
- ✅ Reports: "Discriminators needed: CFTR (lung) vs SLC4A1 (kidney)"

---

## Practical Example: Unknown Gene

**Scenario**: Gene "LRRC15" appears in your list but is not in the skill's marker database.

**Multi-Method Analysis:**

**Method 1: Known Markers**
- Result: NOT FOUND in predefined list

**Method 2: Enrichment Analysis**
```python
enrichr(['LRRC15'], 'Human_Gene_Atlas')
# Top result: "Fibroblasts" (p = 0.001)
```

**Method 3: GO/Pathway**
```python
go_enrichment(['LRRC15'])
# Top terms: "collagen fibril organization", "extracellular matrix"
# Inference: Likely fibroblast/stromal cell
```

**Method 4: Literature Mining**
```
PubMed search: "LRRC15 cell type"
# Abstracts mention: "cancer-associated fibroblast marker"
# Abstracts mention: "myofibroblast"
```

**Method 5: Expression Database**
```
Human Protein Atlas: LRRC15
# Cell type distribution: High in fibroblasts, CAFs
# Tissue: Connective tissue, stroma
```

**Method 6: Co-expression**
```
STRING: LRRC15 co-expressed with:
- COL1A1, FN1, POSTN (all fibroblast markers)
```

**Consensus:**
- **Cell Type**: Cancer-Associated Fibroblasts (CAFs)
- **Confidence**: HIGH
- **Evidence**: 5/5 methods concordant

---

## Special Cases and Challenges

### Case 1: Ambiguous Genes (Multiple Cell Types)

**Example**: CD44 (stem cells, some T cells, fibroblasts, tumor cells)

**Strategy:**
- Look at OTHER genes in the list
- Context matters: If list has tumor markers → likely tumor cells
- If list has T cell markers → likely T cells
- Check expression level patterns

### Case 2: Ubiquitous Genes

**Example**: GAPDH, ACTB (housekeeping genes)

**Strategy:**
- These don't indicate cell type
- Flag and exclude from analysis
- Focus on cell-type-restricted genes

### Case 3: Novel/Poorly Characterized Genes

**Example**: New lncRNAs, uncharacterized ORFs

**Strategy:**
- Rely heavily on co-expression
- Use guilt-by-association
- Lower confidence in final assignment
- May require experimental validation

### Case 4: Mixed Populations

**Example**: Gene list contains markers for multiple cell types

**Strategy:**
- Identify ALL represented cell types
- Report as "mixed population" or "TME signature"
- Estimate relative proportions if possible
- Consider biological context (tumor tissue = expected mixed)

---

## Recommended Default Workflow for Agents

```python
def agent_cell_type_identification(gene_list):
    """
    Recommended workflow for AI agent to identify cell types
    from ANY gene list, including unknown genes.
    """
    
    # STEP 1: Quick check against known markers (predefined in skill)
    print("[Step 1] Checking known marker databases...")
    known_result = check_marker_database(gene_list)
    
    if known_result['confidence'] == 'HIGH':
        # 3+ markers found, high confidence
        return known_result
    
    # STEP 2: Enrichment analysis (works for any genes)
    print("[Step 2] Running cell-type enrichment analysis...")
    enrichment_result = run_enrichment_analysis(
        gene_list,
        libraries=['Human_Gene_Atlas', 'ARCHS4_Tissues', 'Tabula_Sapiens']
    )
    
    # STEP 3: For genes not clearly identified, query additional resources
    unidentified_genes = identify_unknown_genes(gene_list, known_result)
    
    if len(unidentified_genes) > 0:
        print(f"[Step 3] {len(unidentified_genes)} genes need additional analysis...")
        
        # Functional annotation
        functional_result = go_pathway_analysis(unidentified_genes)
        
        # Web search for cell type associations (if needed)
        if len(unidentified_genes) <= 5:  # Limit to avoid too many queries
            web_results = {}
            for gene in unidentified_genes:
                web_results[gene] = web_search_cell_type(gene)
    
    # STEP 4: Build consensus
    print("[Step 4] Building consensus...")
    consensus = integrate_all_evidence(
        known_markers=known_result,
        enrichment=enrichment_result,
        functional=functional_result,
        web_evidence=web_results if 'web_results' in locals() else None
    )
    
    # STEP 5: Assess confidence and report
    final_result = {
        'cell_types': consensus['cell_types'],
        'confidence': consensus['confidence'],
        'evidence': {
            'known_markers': known_result,
            'enrichment': enrichment_result,
            'functional': functional_result if 'functional_result' in locals() else None
        },
        'method_concordance': consensus['concordance']
    }
    
    return final_result


def web_search_cell_type(gene):
    """
    Use web search to find cell type associations for a gene.
    """
    # Search pattern
    query = f"{gene} cell type expression marker"
    
    # This would use web_search tool
    results = web_search(query)
    
    # Extract cell type mentions from search results
    cell_type_mentions = extract_cell_types_from_text(results)
    
    return cell_type_mentions
```

---

## Key Recommendations for Agents

**Priority Order:**

1. **Always try enrichment analysis first** (works for any genes, statistical)
2. **Use GO/pathway annotation** as secondary evidence
3. **Web search for unknowns** (use sparingly, 3-5 genes max per query)
4. **Build consensus** from multiple methods (never rely on single method)
5. **Report confidence** explicitly (HIGH/MEDIUM/LOW)
6. **Show evidence** for transparency

**Never:**
- Claim you "don't recognize" genes without trying enrichment
- Rely only on predefined marker lists
- Give high confidence with single-method evidence
- Ignore genes just because they're unknown

**Always:**
- Try computational methods before giving up
- Combine multiple sources of evidence
- Report uncertainty honestly
- Provide reasoning for cell type assignment

---

## Summary

### The Agent Should:

✅ **First**: Check predefined markers (fast, high confidence if found)

✅ **Second**: Run enrichment analysis (works for ANY genes)

✅ **Third**: Use GO/pathway functional annotation

✅ **Fourth**: Query expression databases for unknown genes

✅ **Fifth**: Use web search strategically for critical unknowns

✅ **Always**: Build consensus from multiple methods

✅ **Always**: Report confidence level (HIGH/MEDIUM/LOW)

### The Agent Should NOT:

❌ Claim inability to identify cell types without trying multiple methods

❌ Rely solely on predefined marker lists

❌ Ignore genes not in skill database

❌ Give definitive answers without consensus

❌ Skip enrichment analysis (most powerful general method)

### Example Agent Response Pattern:

```
"I'll identify the cell types using multiple methods:

[Step 1] Checking against known marker databases...
- Found: CD8A → CD8+ T cells
- Not found: GENE_X, GENE_Y

[Step 2] Running enrichment analysis on all genes...
- Top enrichment: "Macrophages" (p = 1e-5)
- Supporting evidence: GENE_X, GENE_Y enriched in macrophage signatures

[Step 3] Functional annotation of unknown genes...
- GENE_X: GO term 'phagocytosis' → supports macrophage
- GENE_Y: Pathway 'TLR signaling' → supports macrophage

[Consensus]
Cell Type: Macrophages (likely M2-polarized based on specific markers)
Confidence: HIGH
Methods concordant: 3/3 (markers, enrichment, functional)
"
```

This approach ensures robust cell type identification regardless of whether genes are in predefined lists.
