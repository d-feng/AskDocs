# EcoTyper Implementation Framework for Gene List Analysis

## Executive Summary

**EcoTyper** is a machine learning framework for identifying:
1. **Cell states** - Transcriptionally defined phenotypes within cell types
2. **Ecotypes** - Multicellular communities (co-occurring cell states across samples)

**Key Innovation:** Goes beyond simple "hot" vs "cold" TME classification to identify 10 distinct multicellular ecosystems with clinical relevance.

---

## Core Concepts from EcoTyper Paper

### What is an Ecotype?

**Definition:** A multicellular community defined as a collection of cell states that co-occur across independent tissue samples.

**Key Features:**
- Discovered in 16 types of human carcinoma (6,000 tumors)
- 10 ecotypes identified, each with 3-9 distinct cell states
- Clinically distinct (different prognosis, ICI response)
- Spatially distinct (different spatial topology)
- Conservation across tumor types

### The 10 Carcinoma Ecotypes (CEs)

From the paper analysis:

**CE1-CE2:** Lymphocyte-deficient, adverse survival
- CE1: POSTN+ fibroblasts, basal-like epithelial
- CE2: Similar but distinct stromal composition

**CE3:** Myeloid-enriched, MSI-high, adverse survival
- COSMIC mutational signature 17
- Gastric reflux-associated

**CE4:** Myogenesis, male >60 years
- Field effect (present in adjacent normal)

**CE5:** Smoking-related mutations

**CE6:** Normal tissue enriched

**CE7:** Age-related mutations

**CE8:** Moderately favorable outcomes

**CE9:** Proinflammatory ("Hot"), BEST ICI response ⭐
- IFN-γ signaling high
- T cells: LAG3+ CD8 (exhausted), CTLA4+ CD4
- Macrophages: M1-like (CXCL9+)
- DCs: Mature immunogenic
- B cells: Activated
- **Spatial:** T cells in tumor CENTER
- **Clinical:** Superior OS, best ICI predictor

**CE10:** Proinflammatory ("Warm"), favorable prognosis ⭐
- T cells: CCR7+ naive/central memory
- Monocytes: Pro-inflammatory (CCR2+)
- DCs: cDC1-like (XCR1+)
- B cells: Naive/resting
- **Spatial:** T cells at tumor PERIPHERY
- **Clinical:** Good OS, present in adjacent normal (field effect)

---

## EcoTyper Methodology

### Step 1: Digital Cytometry (CIBERSORTx)

**Purpose:** Deconvolve bulk RNA-seq into cell-type-specific expression profiles

**Input:** Bulk tumor transcriptomes (TPM/CPM normalized)

**Process:**
1. Use signature matrix (LM22 for immune, TR4 for epithelial/stroma)
2. Estimate cell type fractions per sample
3. Impute cell-type-specific gene expression profiles (G matrix)

**Output:** Matrix G with dimensions: genes × samples × cell types

### Step 2: Cell State Discovery (NMF)

**Purpose:** Identify transcriptional states within each cell type

**Process:**
1. For each cell type i, extract expression matrix Vi from G
2. Log2 transform and standardize each gene (mean=0, SD=1)
3. "Posneg transform" to satisfy NMF non-negativity constraint
4. Apply NMF with Kullback-Leibler divergence
   - Vi = W × H
   - W = basis matrix (gene weights for each state)
   - H = mixture coefficients (state abundances per sample)
5. Select rank k (number of states) using cophenetic coefficient
6. Apply quality control filters:
   - **AFI (Adaptive False Positive Index):** Remove states with AFI ≥ 1
   - **Marker genes:** Require ≥10 marker genes per state
   - **Dropout score:** Remove states with anomalous low variance

**Output:** 
- W matrix (cell state signatures)
- H matrix (cell state abundances per sample)
- 69 cell states across 12 cell types

### Step 3: Ecotype Discovery

**Purpose:** Identify co-occurring cell states (multicellular communities)

**Process:**
1. Discretize H matrix into binary (most abundant state per cell type = 1)
2. Calculate pairwise Jaccard indices between all cell states
3. Filter non-significant overlaps (hypergeometric test, p > 0.01)
4. Hierarchical clustering (average linkage, Euclidean distance)
5. Optimize cluster number by silhouette width maximization
6. Remove clusters with <3 states

**Output:** 10 ecotypes (CEs), each with 3-9 cell states

### Step 4: Ecotype Recovery (Prediction)

**Purpose:** Predict ecotypes in new samples

**Process:**
1. Use fixed W matrices from discovery cohort
2. For new expression matrix M', solve: M' = W × H'
3. Iteratively update H' until convergence
4. Calculate ecotype abundance by averaging constituent cell state abundances
5. Assign sample to ecotype with highest abundance (q < 0.25)

---

## Implementation Strategy for Gene Lists

### Approach 1: Reference-Guided Annotation (Simplest)

**Use Case:** You have a DEG list and want to know which ecotype it represents

**Steps:**

1. **Obtain EcoTyper Signatures**
   - Download from https://ecotyper.stanford.edu/carcinoma
   - W matrices for all 69 cell states
   - CE definitions (which states belong to which ecotypes)

2. **Map Your Genes to Cell States**
   ```python
   def map_genes_to_states(gene_list, ecotyper_signatures):
       """
       gene_list: Your DEG list with gene symbols
       ecotyper_signatures: Dictionary of W matrices per cell type
       """
       state_scores = {}
       
       for cell_type, W_matrix in ecotyper_signatures.items():
           for state_id, state_genes in W_matrix.items():
               # Calculate overlap
               overlap = set(gene_list) & set(state_genes)
               
               # Calculate enrichment score
               if len(overlap) > 0:
                   # Fisher's exact test or hypergeometric
                   p_value = fisher_exact_test(
                       overlap_count=len(overlap),
                       gene_list_size=len(gene_list),
                       state_size=len(state_genes),
                       universe_size=20000
                   )
                   state_scores[(cell_type, state_id)] = {
                       'p_value': p_value,
                       'overlap': len(overlap),
                       'genes': overlap
                   }
       
       return state_scores
   ```

3. **Aggregate to Ecotypes**
   ```python
   def predict_ecotype(state_scores, ce_definitions):
       """
       state_scores: Output from map_genes_to_states
       ce_definitions: Which states belong to which CEs
       """
       ce_scores = {}
       
       for ce_id, ce_states in ce_definitions.items():
           # Count how many CE states are enriched
           enriched_states = [
               s for s in ce_states 
               if s in state_scores and state_scores[s]['p_value'] < 0.05
           ]
           
           # Calculate CE score
           if len(enriched_states) > 0:
               ce_scores[ce_id] = {
                   'n_states': len(enriched_states),
                   'fraction': len(enriched_states) / len(ce_states),
                   'mean_p': np.mean([state_scores[s]['p_value'] for s in enriched_states])
               }
       
       # Predict ecotype
       if ce_scores:
           predicted_ce = max(ce_scores.items(), key=lambda x: x[1]['fraction'])
           return predicted_ce
       else:
           return None
   ```

### Approach 2: Signature-Based Scoring (More Robust)

**Use Case:** You have expression data and want quantitative ecotype scores

**Steps:**

1. **Create Ecotype Metagenes**
   ```python
   def create_ecotype_metagenes(ecotyper_data):
       """
       Aggregate cell state signatures into ecotype signatures
       """
       ecotype_signatures = {}
       
       for ce_id, ce_info in ecotyper_data['ecotypes'].items():
           # Collect all genes from states in this CE
           ce_genes = []
           ce_weights = {}
           
           for cell_type, state_id in ce_info['states']:
               state_signature = ecotyper_data['signatures'][cell_type][state_id]
               
               for gene, weight in state_signature.items():
                   if gene not in ce_weights:
                       ce_weights[gene] = []
                   ce_weights[gene].append(weight)
           
           # Average weights across states
           ecotype_signatures[ce_id] = {
               gene: np.mean(weights) 
               for gene, weights in ce_weights.items()
           }
       
       return ecotype_signatures
   ```

2. **Score Your Data**
   ```python
   def score_ecotypes(expression_data, ecotype_signatures):
       """
       expression_data: Gene expression matrix (genes × samples)
       ecotype_signatures: Output from create_ecotype_metagenes
       """
       ecotype_scores = pd.DataFrame(
           index=expression_data.columns,  # samples
           columns=ecotype_signatures.keys()  # CEs
       )
       
       for sample in expression_data.columns:
           sample_expr = expression_data[sample]
           
           for ce_id, ce_signature in ecotype_signatures.items():
               # Calculate enrichment score (e.g., ssGSEA, z-score)
               score = ssgsea_score(sample_expr, ce_signature)
               ecotype_scores.loc[sample, ce_id] = score
       
       return ecotype_scores
   ```

### Approach 3: Full NMF Implementation (Most Accurate)

**Use Case:** You want to replicate EcoTyper exactly

**Steps:**

1. **Cell Type Deconvolution**
   - Use CIBERSORTx or similar (EPIC, quanTIseq, xCell)
   - Get cell type fractions
   - Impute cell-type-specific expression

2. **NMF on Each Cell Type**
   ```python
   from sklearn.decomposition import NMF
   
   def discover_cell_states(purified_expression, n_states):
       """
       purified_expression: Cell-type-specific expression (genes × samples)
       n_states: Number of states to discover (or determine by cophenetic)
       """
       # Log2 and standardize
       X = np.log2(purified_expression + 1)
       X_std = (X - X.mean(axis=1, keepdims=True)) / X.std(axis=1, keepdims=True)
       
       # Posneg transform
       X_pos = np.maximum(X_std, 0)
       X_neg = np.maximum(-X_std, 0)
       X_combined = np.vstack([X_pos, X_neg])
       
       # NMF
       model = NMF(n_components=n_states, init='nndsvd', max_iter=500)
       H = model.fit_transform(X_combined.T).T  # mixture coefficients
       W = model.components_.T  # basis matrix
       
       # AFI filtering
       n_genes = X.shape[0]
       AFI = W[n_genes:, :].sum(axis=0) / W[:n_genes, :].sum(axis=0)
       valid_states = AFI < 1
       
       return W[:, valid_states], H[valid_states, :]
   ```

3. **Ecotype Discovery**
   ```python
   from sklearn.cluster import AgglomerativeClustering
   from sklearn.metrics import silhouette_score
   
   def discover_ecotypes(H_matrices, max_k=20):
       """
       H_matrices: Dictionary of H matrices per cell type
       """
       # Discretize to binary (most abundant state per cell type)
       binary_matrix = np.zeros((n_states_total, n_samples))
       
       state_idx = 0
       for cell_type, H in H_matrices.items():
           max_states = H.argmax(axis=0)
           for sample_idx in range(n_samples):
               binary_matrix[state_idx + max_states[sample_idx], sample_idx] = 1
           state_idx += H.shape[0]
       
       # Jaccard matrix
       jaccard = calculate_jaccard_matrix(binary_matrix)
       
       # Filter non-significant
       jaccard_filtered = filter_by_hypergeometric(jaccard, binary_matrix)
       
       # Hierarchical clustering
       best_k = None
       best_silhouette = -1
       
       for k in range(2, max_k + 1):
           clustering = AgglomerativeClustering(
               n_clusters=k,
               affinity='euclidean',
               linkage='average'
           )
           labels = clustering.fit_predict(1 - jaccard_filtered)
           silhouette = silhouette_score(1 - jaccard_filtered, labels)
           
           if silhouette > best_silhouette:
               best_silhouette = silhouette
               best_k = k
               best_labels = labels
       
       # Filter clusters with <3 states
       ecotypes = filter_small_clusters(best_labels, min_size=3)
       
       return ecotypes
   ```

---

## Practical Implementation for Your Use Case

### Scenario: Predict Ecotype from Your DEG List

**Input:** 224-gene stratified signature from lung adenocarcinoma
- 108 upregulated (gained populations)
- 116 downregulated (lost populations)

**Goal:** Determine which ecotype(s) this represents

### Implementation:

```python
import pandas as pd
import numpy as np
from scipy.stats import fisher_exact
from statsmodels.stats.multitest import multipletests

class EcoTypePredictor:
    def __init__(self, ecotyper_reference_path):
        """
        Load EcoTyper reference data
        """
        self.load_reference(ecotyper_reference_path)
    
    def load_reference(self, path):
        """
        Load pre-computed EcoTyper signatures and CE definitions
        """
        # Cell state signatures (W matrices)
        self.cell_state_signatures = pd.read_csv(f"{path}/cell_state_signatures.csv")
        
        # CE definitions (which states in which CEs)
        self.ce_definitions = pd.read_csv(f"{path}/ecotype_definitions.csv")
        
        # Cell state marker genes
        self.state_markers = pd.read_csv(f"{path}/state_marker_genes.csv")
    
    def predict_from_gene_list(self, upregulated_genes, downregulated_genes):
        """
        Predict ecotype from up/down gene lists
        """
        results = {
            'upregulated': self.analyze_gene_list(upregulated_genes, direction='up'),
            'downregulated': self.analyze_gene_list(downregulated_genes, direction='down'),
        }
        
        # Integrate results
        ecotype_prediction = self.integrate_predictions(results)
        
        return ecotype_prediction
    
    def analyze_gene_list(self, gene_list, direction='up'):
        """
        Map genes to cell states
        """
        enrichments = []
        
        # For each cell state
        for idx, row in self.state_markers.iterrows():
            cell_type = row['cell_type']
            state_id = row['state_id']
            marker_genes = eval(row['marker_genes'])  # list of genes
            
            # Calculate overlap
            overlap = set(gene_list) & set(marker_genes)
            
            if len(overlap) > 0:
                # Fisher's exact test
                a = len(overlap)  # overlap
                b = len(gene_list) - a  # in gene_list but not marker
                c = len(marker_genes) - a  # in marker but not gene_list
                d = 20000 - a - b - c  # neither
                
                odds_ratio, p_value = fisher_exact([[a, b], [c, d]], alternative='greater')
                
                enrichments.append({
                    'cell_type': cell_type,
                    'state_id': state_id,
                    'overlap_count': len(overlap),
                    'overlap_genes': list(overlap),
                    'p_value': p_value,
                    'odds_ratio': odds_ratio
                })
        
        # Multiple testing correction
        df = pd.DataFrame(enrichments)
        if len(df) > 0:
            df['q_value'] = multipletests(df['p_value'], method='fdr_bh')[1]
        
        return df
    
    def integrate_predictions(self, results):
        """
        Combine up/down results to predict ecotype
        """
        # Get significant states
        up_states = set(results['upregulated'][
            results['upregulated']['q_value'] < 0.05
        ][['cell_type', 'state_id']].apply(tuple, axis=1))
        
        down_states = set(results['downregulated'][
            results['downregulated']['q_value'] < 0.05
        ][['cell_type', 'state_id']].apply(tuple, axis=1))
        
        # Score each ecotype
        ce_scores = []
        
        for ce_id in self.ce_definitions['CE'].unique():
            ce_states = set(self.ce_definitions[
                self.ce_definitions['CE'] == ce_id
            ][['cell_type', 'state_id']].apply(tuple, axis=1))
            
            # Calculate matches
            gained_match = len(up_states & ce_states)
            lost_match = len(down_states & ce_states)
            
            ce_scores.append({
                'ecotype': ce_id,
                'gained_states_matched': gained_match,
                'total_ce_states': len(ce_states),
                'gained_fraction': gained_match / len(ce_states) if len(ce_states) > 0 else 0,
                'lost_states_matched': lost_match,
                'total_score': (gained_match - lost_match) / len(ce_states) if len(ce_states) > 0 else 0
            })
        
        df_scores = pd.DataFrame(ce_scores).sort_values('total_score', ascending=False)
        
        return {
            'predicted_ecotype': df_scores.iloc[0]['ecotype'],
            'confidence': df_scores.iloc[0]['total_score'],
            'all_scores': df_scores,
            'enriched_states_up': up_states,
            'enriched_states_down': down_states
        }


# Usage
predictor = EcoTypePredictor('/path/to/ecotyper/reference')

# Your gene lists
upregulated = ['CXCL13', 'SDC1', 'MZB1', 'JCHAIN', 'FOXP3', 'CCL22', ...]
downregulated = ['PRF1', 'NKG7', 'GNLY', 'DEFA1', 'MPO', 'ELANE', ...]

# Predict
result = predictor.predict_from_gene_list(upregulated, downregulated)

print(f"Predicted ecotype: {result['predicted_ecotype']}")
print(f"Confidence: {result['confidence']:.3f}")
print("\nAll ecotype scores:")
print(result['all_scores'])
```

---

## Expected Output for Your Lung Adenocarcinoma Case

Based on your gene signature:

**Upregulated:**
- CXCL13 (TLS)
- SDC1, MZB1, JCHAIN (plasma cells)
- FOXP3, CCL22 (Tregs)

**Downregulated:**
- PRF1, NKG7, GNLY (cytotoxic T cells)
- DEFA1/3, MPO, ELANE (neutrophils)
- CD163, MRC1 (macrophages)

**Predicted Ecotype:** Likely **NOT CE9 or CE10** (both are proinflammatory with T cells)

Instead, possibly:
- **CE3** (myeloid-enriched) - but you have myeloid LOSS, so no
- **CE1/CE2** (lymphocyte-deficient, stromal) - possibly, but need stromal markers
- **Novel/Mixed** - Your "Immune Paradox" may represent:
  - Partial CE10 (TLS, plasma cells) 
  - But transitioning away (losing T cells, innate immunity)
  - Not fitting canonical ecotypes

**Interpretation:** Your phenotype appears to be a **dysfunctional CE10** or **failed CE10→CE9 transition**
- Has CE10 features (TLS, plasma cells)
- Lacks CE10 T cells (CCR7+ naive)
- Cannot progress to CE9 (lacks LAG3+ exhausted T cells)
- Result: "Immune Paradox" - TLS+ but non-functional

---

## Data Sources & Files Needed

### From EcoTyper Website (https://ecotyper.stanford.edu/carcinoma)

1. **Cell State Signatures** (W matrices)
   - 69 states × ~1000 genes each
   - Gene weights per state

2. **Ecotype Definitions**
   - Which states belong to which CEs
   - 10 CEs × 3-9 states each

3. **Marker Genes**
   - Top marker genes per state
   - From Table S4 in supplementary

### Format Example:

```
# cell_state_signatures.csv
cell_type,state_id,gene,weight
B_cells,S1,CD19,0.85
B_cells,S1,MS4A1,0.82
...

# ecotype_definitions.csv
CE,cell_type,state_id
CE9,CD8_T,S3
CE9,CD4_T,S1
CE9,Monocyte_Mac,S3
CE9,Dendritic,S3
CE9,B_cells,S5
...

# state_marker_genes.csv
cell_type,state_id,marker_genes
B_cells,S1,"['CD19','MS4A1','PAX5',...]"
Plasma_cells,S1,"['SDC1','MZB1','JCHAIN',...]"
...
```

---

## Advanced: Spatial Ecotype Analysis

If you have spatial transcriptomics data:

```python
def analyze_spatial_ecotypes(spatial_data, ecotype_scores):
    """
    Analyze ecotype spatial organization
    """
    from scipy.spatial import distance_matrix
    
    # Calculate distances between spots
    coords = spatial_data[['x', 'y']].values
    distances = distance_matrix(coords, coords)
    
    # For each ecotype
    spatial_stats = {}
    
    for ce in ecotype_scores.columns:
        # Get high-CE spots
        high_ce_spots = ecotype_scores[ce] > ecotype_scores[ce].quantile(0.75)
        
        # Calculate spatial autocorrelation (Moran's I)
        morans_i = calculate_morans_i(
            values=ecotype_scores[ce].values,
            distances=distances
        )
        
        # Distance from tumor cells
        tumor_coords = spatial_data[spatial_data['tumor'] == 1][['x', 'y']].values
        ce_coords = coords[high_ce_spots]
        
        if len(tumor_coords) > 0 and len(ce_coords) > 0:
            min_distances = distance_matrix(ce_coords, tumor_coords).min(axis=1)
            mean_distance = min_distances.mean()
        else:
            mean_distance = np.nan
        
        spatial_stats[ce] = {
            'morans_i': morans_i,
            'mean_distance_to_tumor': mean_distance,
            'aggregation': 'high' if morans_i > 0.5 else 'dispersed'
        }
    
    return pd.DataFrame(spatial_stats).T
```

---

## Integration with Your Framework

### Add to `cell_type_identification_beyond_markers.md`:

```markdown
## Method 7: Ecotype-Based TME Classification

### Concept
Instead of identifying individual cell types or states, classify the entire TME
as one of 10 multicellular ecosystems (ecotypes) with distinct:
- Cellular composition
- Spatial organization  
- Clinical outcomes
- ICI response patterns

### When to Use
- Large DEG datasets (>100 genes) with bidirectional changes
- TME characterization (not just cancer cells)
- Need for treatment recommendation
- Have both upregulated and downregulated genes

### Implementation
1. Map upregulated genes to cell states (gained populations)
2. Map downregulated genes to cell states (lost populations)
3. Aggregate to ecotype predictions
4. Interpret clinically

### Output
- Predicted ecotype (CE1-10)
- Confidence score
- Treatment implications
- Prognosis association

### Example
Gene signature with CXCL13+, SDC1+, FOXP3+ (up) and PRF1-, NKG7- (down)
→ Dysfunctional CE10 (TLS+ but T-cell-excluded)
→ Treatment: Combination therapy (not PD-1 monotherapy)
```

---

## Summary & Recommendations

### For Your Specific Case:

1. **Download EcoTyper Reference Data**
   - Visit https://ecotyper.stanford.edu/carcinoma
   - Download cell state signatures and ecotype definitions

2. **Implement Gene List Mapper**
   - Use Fisher's exact test for enrichment
   - Map to 69 cell states
   - Aggregate to 10 ecotypes

3. **Expected Result**
   - Your "Immune Paradox" phenotype likely doesn't fit canonical ecotypes perfectly
   - Closest: Dysfunctional CE10 or failed CE9 transition
   - This SUPPORTS your novel characterization!

4. **Clinical Utility**
   - Validates that your phenotype is distinct
   - Explains why PD-1 monotherapy won't work
   - Guides combination therapy selection

5. **Framework Integration**
   - Add ecotype prediction as Method 7
   - Complement existing cell state identification
   - Enable TME ecosystem-level classification

### Next Steps:

1. Would you like me to create the actual Python implementation with example data?
2. Should I create a comparison between your "Immune Paradox" and canonical ecotypes?
3. Do you want integration scripts for your existing framework?

Let me know how you'd like to proceed!
