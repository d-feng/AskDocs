# Pathway Label–Gene-Set Discordance and Agentic AI Workflow

## 1. Phenomena

### 1.1 Name-Only Match  
**(Annotation-level match, gene-level mismatch)**

**Definition**  
A situation where two pathway resources share similar or identical **tissue / cell-type / pathway labels**, but their **underlying gene sets show little or no overlap**.

- The label (annotation) matches: e.g., “CD8⁺ T-cell activation”, “Liver metabolism”.
- The gene members differ substantially between databases.

**Consequence**  
- Creates the illusion of agreement across databases when the biology encoded by the gene sets is actually different.
- Can lead to inconsistent enrichment results and confusing cross-database comparisons.

---

### 1.2 Incomplete Pathway Representation  
**(Correct label, missing key regulators)**

**Definition**  
The **pathway name is biologically correct and relevant**, and the gene set partially reflects the real pathway, but **key regulatory genes (master TFs, receptors, signaling hubs) are missing**.

- The label (e.g., “Type I interferon signaling”, “p53 pathway”, “TGF-β signaling”) is accurate.
- Canonical regulators or central nodes are absent (e.g., TP53, IFNAR1/2, SMADs).

**Consequence**  
- The pathway may fail to reach significance in enrichment or network analysis (false negative).
- The inferred regulatory logic is incomplete or distorted.
- Users may incorrectly conclude that the pathway is inactive when, in reality, the curated gene set is incomplete.

---

## 2. Agentic AI Workflow to Mitigate These Issues

We can use an agentic AI pipeline (e.g., multi-agent LLM + Python tools) to **audit and repair** pathway definitions before or alongside enrichment analysis.

### 2.1 Pathway Label Normalizer & Matcher

- Uses an LLM to map pathway names and descriptions from different databases onto **canonical biological concepts** (e.g., “Type I interferon signaling”, “CD8⁺ T-cell activation”).  
- Clusters pathways that represent the **same biology** even when names differ.  
- Computes gene-set overlap (e.g., Jaccard similarity) within each cluster.  
- Flags cases with **high label similarity but low gene-set overlap** as:  
  > **Name-only matches (annotation-level match, gene-level mismatch).**

### 2.2 Regulator Completeness Checker

- For each pathway label, queries prior knowledge:  
  - canonical regulators (TFs, receptors, kinases, hubs),  
  - known markers for the tissue/cell type.  
- Compares the curated gene set to the expected regulators.  
- Computes a **regulator coverage score** (present/expected).  
- Flags pathways with correct labels but low regulator coverage as:  
  > **Incomplete pathway representations (correct label, missing key regulators).**

### 2.3 Gene-Set Repair / Expansion Agent

When a pathway is flagged:

- **Cross-database consensus:**  
  - Integrates genes from multiple databases with the same pathway concept.  
  - Prioritizes genes that appear in multiple resources and have central positions in interaction networks.

- **Data-driven refinement (optional):**  
  - Uses the user’s own data (e.g., DE results, co-expression) to add genes strongly associated with canonical regulators.  

Outputs a **revised gene set** with explicit rationale for each added/removed gene.

### 2.4 Re-Enrichment Evaluator

- Re-runs enrichment (GSEA/ORA) with **original vs. repaired** gene sets.  
- Compares NES, p-values, FDR, and overlap with DE genes.  
- Summarizes whether the repaired sets reduce false negatives or contradictory results.

### 2.5 Biologist-Facing Reporter

- Produces human-readable summaries (e.g., Markdown or PDF) containing:  
  - Tables of **name-only matches** and **incomplete pathway representations**.  
  - Before/after enrichment metrics for key pathways.  
  - Short narrative interpretations suitable for a Results or Methods section.

---

## 3. Suggested Phrasing for a Methods Section

> *We observed frequent pathway label–gene-set discordance across resources. To address this, we implemented an agentic AI workflow. A “Pathway Label Normalizer” agent used an LLM to cluster pathways by biological concept and detect **name-only matches** (annotation-level match, gene-level mismatch). A “Regulator Completeness” agent assessed whether each pathway gene set included canonical regulators and markers, flagging **incomplete pathway representations** (correct label, missing key regulators). A “Gene-Set Repair” agent then integrated cross-database consensus and data-driven refinement to propose revised gene sets, which were evaluated by re-running enrichment analysis. This workflow helped reduce false negatives and improved the biological consistency of pathway-level interpretations.*

You can adapt the level of detail depending on whether this appears in a main Methods section or Supplementary Note.


Task 1:
"Compare the gene sets for 'p53 pathway' across MSigDB, KEGG, and Reactome. 
Calculate overlap statistics and identify genes unique to each database."

Task 2:
"Search the literature for comprehensive reviews of p53 pathway regulation 
published 2020-2025. Extract all genes mentioned as pathway regulators or 
components. Create a frequency table."

Task 3:
"Identify genes in the literature-derived list that are MISSING from all 
three databases. For each missing gene, find:
- Direct evidence of role in p53 pathway
- Perturbation experiments (CRISPR/RNAi)
- Protein interactions with known p53 pathway members
Rank by evidence strength."

Task 4:
"For the top 10 missing regulators, generate a summary explaining:
- Their biological role in the pathway
- Why they might have been excluded from databases
- Confidence that they should be included
- Key citations supporting inclusion"

Task 5:
"Create an augmented p53 pathway gene set that:
- Includes all high-confidence regulators
- Annotates each gene with evidence type and confidence
- Organizes genes by pathway position (upstream/core/downstream)
- Flags genes with conflicting evidence"

