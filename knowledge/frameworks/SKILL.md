---
name: oncology-indication-selection
description: Systematic framework for selecting optimal oncology indications for immune cytokine therapeutics. Use this skill when analyzing which cancer types to target for cytokine drug development (IL-2, IL-15, IL-12, IL-21, IFN, etc.), prioritizing indications based on tumor biology, designing clinical development strategies for immunotherapy, or integrating multi-omic data (TCGA, single-cell, pathway analysis) with clinical trial intelligence and real-world evidence to make data-driven indication selection decisions.
---

# Oncology Indication Selection for Immune Cytokines

Systematic framework for identifying and prioritizing optimal cancer indications for immune cytokine therapeutics through integrated analysis of tumor biology, clinical precedent, and market opportunity.

## Core Strategy

Start with mechanism-driven hypotheses based on cytokine MOA, validate through biological data (TME profiling, immune archetypes, cell states, pathways), filter through clinical feasibility (checkpoint precedent, trial intelligence), assess competitive landscape (patents, clinical programs, failures), and score commercial opportunity (addressable population, unmet need, competition).

**Decision Formula:**
```
Final Score = 0.30 × Biological + 0.25 × Clinical + 0.20 × Commercial + 0.25 × (1 - Competitive Risk)
```

**Enhanced with Competitive Intelligence:**
- Patent landscape analysis to identify freedom-to-operate and white space
- Clinical program tracking to understand competitive positioning
- Failure analysis to learn from others' setbacks
- Success case studies to replicate winning strategies

## Quick Start Workflow

### Step 1: Define Cytokine MOA Profile (Day 1)

Document mechanism to guide analysis:

```markdown
**Cytokine:** [Your molecule name]
**Primary targets:** [CD8+ T cells / NK cells / DC / etc.]
**Receptor:** [IL-2Rβ/γ / IL-15R / etc.]
**Signaling:** [JAK-STAT / other pathways]
**Key effects:** [Proliferation / cytotoxicity / polarization]
**Required TME:** [Hot / excluded / specific cell states]
**Toxicity profile:** [CRS / capillary leak / autoimmune risk]
```

### Step 2: Initial Screening - Biological (Week 1)

Rank 30+ cancer types by immune biology:

**TCGA Immune Analysis:**
```python
# Pseudocode for initial screening
for cancer_type in TCGA_cancers:
    scores[cancer_type] = {
        'leukocyte_fraction': get_tcga_leukocyte(cancer_type),
        'target_cell_abundance': get_cell_estimate(cancer_type, target='CD8_T'),
        'immune_subtype_dist': get_immune_subtypes(cancer_type)
    }
    
# Rank by target cell presence
ranked = sort_by(scores, 'target_cell_abundance', descending=True)
top_15 = ranked[:15]
```

**Data Sources:**
- TCGA PanCancer immune estimates (CIBERSORT, xCell)
- Thorsson immune subtypes (Cell 2018)
- Filter: Require >10% target cell abundance or favorable immune archetype

### Step 3: Add Clinical Precedent Filter (Week 1)

```python
# Check checkpoint inhibitor responses
for cancer in top_15:
    io_response[cancer] = {
        'anti_PD1_ORR': query_literature(cancer, 'pembrolizumab'),
        'combo_ORR': query_literature(cancer, 'ipi+nivo'),
        'approval_status': check_FDA(cancer)
    }

# Filter: Keep if checkpoint ORR >10% (proven immune biology)
viable = [c for c in top_15 if io_response[c]['anti_PD1_ORR'] > 0.10]
```

**Rationale:** 10-40% checkpoint response = established biology + room for improvement

### Step 4: Deep Biological Profiling (Week 2-4)

For each viable indication, characterize in detail:

**A. Cell State Analysis (Single-Cell)**

Load TISCH or published single-cell datasets:

```python
for indication in viable_indications:
    sc_data = load_single_cell(indication, source='TISCH')
    target_cells = subset(sc_data, cell_type=cytokine_target)
    
    # Classify dysfunction states
    states = score_signatures(target_cells, {
        'progenitor_exhausted': ['TCF7', 'LEF1', 'PDCD1'],
        'terminal_exhausted': ['HAVCR2', 'LAG3', 'TIGIT', 'TOX'],
        'effector': ['GZMB', 'PRF1', 'IFNG']
    })
    
    # Score compatibility
    compatibility = sum(
        state_prevalence[s] * cytokine_fit[s] 
        for s in states
    )
```

**Cell State Responsiveness (Example: IL-15)**
- Progenitor exhausted (TCF7+): 0.95 (excellent)
- Early dysfunction (PD-1+ only): 0.85 (good)
- Terminal exhaustion (multi-marker+): 0.10 (poor)

**B. Immune Archetype Mapping**

Use Thorsson TCGA immune subtypes:

**Archetype Compatibility Matrix:**
```
C1 (Wound Healing, TGF-β high):     Variable (may need combo)
C2 (IFN-γ Dominant):                Excellent for most cytokines
C3 (Inflammatory):                  Good (watch toxicity)
C4 (Lymphocyte Depleted):           Poor (need priming)
C5 (Immunologically Quiet):         Poor
C6 (TGF-β Dominant):                Requires TGF-β blockade
```

Calculate: `Score = Σ(archetype_prevalence × MOA_fit)`

**C. Pathway Integrity**

```python
# Check signaling pathway status
pathway_score = (
    receptor_expression *          # IL2Rβ/γ on target cells
    JAK_STAT_activity *            # ssGSEA pathway score
    (1 - suppressor_penalty)       # SOCS3, PTPN6 levels
)
```

Use MSigDB Hallmark gene sets for pathway scoring via ssGSEA.

### Step 5: Clinical Intelligence (Week 3-4)

**A. Trial Data Extraction**

```python
# Query ClinicalTrials.gov
trials = search_ct_gov(
    condition=indication,
    intervention=['checkpoint inhibitor', 'immunotherapy'],
    status='Completed'
)

# Extract benchmarks
benchmark_ORR = median([t.ORR for t in trials if t.has_results()])
competition_index = count(trials, status='Recruiting')
```

**B. Response Pattern Analysis**

Create matrix of checkpoint responses:
```
              Anti-PD1  Combo    Cytokine Strategy
Melanoma        40%     58%      Post-IO or combo to boost CR
RCC             25%     42%      Excellent precedent (HD IL-2)
NSCLC           20%     36%      Biomarker-select (PD-L1+)
MSI-H (any)     55%     -        Combo to convert non-responders
TNBC            10%     -        Inflamed subset only
Pancreatic       3%     -        Avoid (needs priming first)
```

### Step 6: Real-World Data Integration (Week 4)

**Treatment Patterns & Unmet Need:**

```python
rwd_analysis = {
    'addressable_pop': (
        annual_incidence *
        metastatic_rate *
        reach_target_line *
        eligibility_fraction
    ),
    'unmet_need_score': (
        0.40 * (1 - normalize(SOC_PFS)) +      # Low efficacy
        0.30 * progression_rate_1yr +           # High progression
        0.30 * (1/(approved_options + 1))       # Few alternatives
    ),
    'market_value': addressable_pop * price * share_assumption
}
```

**Data Sources:**
- SEER: Incidence, prevalence
- Flatiron (if available): Treatment patterns, rwPFS/rwOS
- Literature: SOC efficacy benchmarks

### Step 7: Competitive Intelligence (Week 5-6)

**A. Patent Landscape Analysis**

Search Google Patents or patent databases:

```python
# Query recent patents (2020-2025)
search_terms = f"{cytokine_name} AND (cancer OR tumor) AND (engineered OR fusion)"

for patent in search_results:
    extract_data = {
        'publication_number': patent.id,
        'assignee': patent.owner,
        'technology_class': classify_technology(patent),
        'exemplified_indications': extract_indications(patent.examples),
        'blocking_potential': assess_fto_risk(patent, your_format)
    }
```

**Competitive patent metrics:**
- Patent crowding score: Count of relevant patents per indication
- FTO risk: Do broad claims block your format?
- White space: Indications with fewer patents

**B. Clinical Program Tracking**

```python
# Map active competitors
programs = query_ct_gov(
    intervention=cytokine_class,
    condition=target_indications,
    status=['Recruiting', 'Active']
)

competitive_matrix = {
    'Phase 3': count([p for p in programs if p.phase == 'III']),
    'Phase 2': count([p for p in programs if p.phase == 'II']),
    'Recent failures': identify_terminated(programs, last_2_years=True)
}
```

**C. Failure Analysis**

Review major setbacks 2021-2025:
- Bempegaldesleukin (PEG-IL-2): Failed Ph3 in melanoma, RCC, bladder
- Nemvaleukin alfa: Stopped Ph3 in ovarian cancer (futility)
- Efbalropendekin alfa: Discontinued Ph1

**Extract lessons:**
```python
failure_lessons = {
    'bempeg': 'PEGylation insufficient to solve Treg bias',
    'nemvaleukin': 'Cold TME in late-line ovarian resistant to IL-2',
    'efbalro': 'IL-15 format optimization critical for safety'
}

# Apply to your indication
if your_indication == 'ovarian' and your_class == 'IL-2':
    risk_flag = 'HIGH - similar to nemvaleukin failure'
```

**D. Competitive Risk Scoring**

```python
competitive_risk = (
    0.25 * patent_crowding_score +
    0.35 * clinical_competition_score +
    0.25 * regulatory_bar_score +
    0.15 * recent_failure_penalty
)

# Interpretation:
# <0.3: Low competition (opportunity)
# 0.3-0.6: Moderate (need differentiation)
# >0.6: High (risky, avoid unless clearly superior)
```

**Key outputs:**
- Patent landscape map (technology clusters, assignees, trends)
- Competitive clinical matrix (active programs by phase)
- Failure lessons learned (avoid repeat mistakes)
- Competitive risk score per indication

**Reference:** See `references/competitive-intelligence.md` for detailed workflows

### Step 8: Integrated Scoring (Week 7)

**A. Biological Plausibility (0-1.0, weight 40%)**

```python
bio_score = (
    0.30 * target_cell_abundance_score +
    0.25 * cell_state_compatibility +
    0.20 * pathway_integrity +
    0.25 * archetype_fit_score
)
```

**B. Clinical Feasibility (0-1.0, weight 35%)**

```python
clin_score = (
    0.35 * normalize(checkpoint_ORR, max=60%) +
    0.20 * enrollment_feasibility +
    0.20 * biomarker_validation +
    0.25 * regulatory_clarity
)
```

**C. Commercial Opportunity (0-1.0, weight 25%)**

```python
comm_score = (
    0.35 * normalize(addressable_pop, max=50000) +
    0.30 * unmet_need_score +
    0.20 * (1 - competition_intensity) +
    0.15 * market_value_score
)
```

**D. Competitive Opportunity (0-1.0, weight 25%)**

```python
competitive_risk = (
    0.25 * patent_crowding +           # IP freedom
    0.35 * clinical_competition +      # Active programs
    0.25 * regulatory_bar +            # Approval difficulty
    0.15 * recent_failure_penalty      # Similar failures
)

competitive_advantage = 1 - competitive_risk  # Invert for scoring
```

**E. Final Composite**

```python
final_score = (
    0.30 * bio + 
    0.25 * clin + 
    0.20 * comm + 
    0.25 * competitive_advantage
)

# Apply risk adjustments
if terminal_exhaustion_high: final_score *= 0.85
if pathway_deficient: final_score *= 0.75
```

**Decision Thresholds:**
- ≥0.75: Lead indication
- 0.65-0.74: Strong backup
- 0.55-0.64: Exploratory
- <0.55: Deprioritize

### Step 8: Generate Evidence Packages (Week 6)

For top 3-5 indications, create comprehensive profiles:

**Template Structure:**
```markdown
# [Cancer Type] Indication Profile

## Executive Summary
- Overall Score: 0.XX (Rank #X)
- Recommendation: Lead / Backup / Exploratory

## Biological Rationale (Score: 0.XX)
### TME Profile
- Immune infiltration: Hot/Cold/Excluded
- Target cell abundance: XX% of leukocytes
- Predominant states: [Progenitor 40%, Early dysfunction 30%]
- Dominant archetypes: [C2: 45%, C3: 30%]

### Pathway Status
- Receptor expression: [High/Medium/Low]
- JAK-STAT activity: [Score]
- Suppressors: [SOCS3, TGF-β levels]

## Clinical Precedent (Score: 0.XX)
- Checkpoint ORR: XX%
- Historical cytokine data: [IL-2, IFN experience]
- Trial competition: XX active trials

## Market Opportunity (Score: 0.XX)
- Addressable population: XX,XXX/year
- Unmet need: [High/Medium/Low]
- Peak sales potential: $XXM-XB

## Development Strategy
### Recommended Phase
- Phase 1b/2, [biomarker-selected/unselected]
- N = XX patients
- Primary: ORR | Secondary: PFS, safety, biomarkers

### Biomarker Strategy
- Enrollment: [PD-L1+, TMB-high, immune archetype]
- Stratification: [Key variables]
- Exploratory: [Spatial, TCR sequencing]

### Combination Rationale
- Partners: [Anti-PD-1, other]
- Synergy hypothesis: [Mechanism]
- Safety: [Overlapping toxicities]

## Risk Assessment
**Technical:** Pathway suppression, delivery barriers
**Competitive:** Crowded landscape, high benchmark
**Commercial:** Small population, reimbursement
```

## Indication-Specific Guidance

### High-Priority Indications (Strong Biology + Precedent)

**Melanoma**
- Biology: Hot, high TMB, progenitor exhausted T cells abundant
- Precedent: HD IL-2 ORR 16%, checkpoint 40-58%
- Strategy: Combination for CR improvement, 2L post-IO
- Challenge: Very competitive, small metastatic population

**Renal Cell Carcinoma**
- Biology: Constitutively inflamed, balanced T cell states
- Precedent: Best historical cytokine indication (IL-2 approved)
- Strategy: 2L post-IO, CR rate improvement
- Challenge: IO+TKI combos now SOC

**MSI-High (Tissue-Agnostic)**
- Biology: Very high TMB, universally hot
- Precedent: Checkpoint ORR 40-60%
- Strategy: Convert non-responders, deepen responses
- Challenge: Already high response rates

### Moderate-Priority (Subset Biology or Emerging Data)

**NSCLC**
- Biology: Heterogeneous (30% hot, 30% excluded, 40% cold)
- Precedent: Checkpoint ORR 20% (45% if PD-L1 high)
- Strategy: Biomarker-select inflamed subset
- Challenge: Hyper-competitive, elderly patients

**Triple-Negative Breast Cancer**
- Biology: 20-30% immune-enriched subset
- Precedent: Checkpoint+chemo ORR 53% (PD-L1+)
- Strategy: TIL-high or inflamed subset
- Challenge: Requires robust biomarker

**Hepatocellular Carcinoma**
- Biology: Immunosuppressive (TGF-β, Tregs)
- Precedent: Atezo+bev ORR 27%
- Strategy: Combination with TGF-β blockade
- Challenge: Cirrhotic patients, tolerability

### Avoid/High-Risk Indications

**Glioblastoma**
- Biology: Cold, immune-privileged
- Precedent: Checkpoint no benefit
- Strategy: Only if intratumoral delivery feasible
- Risk: Very high technical failure risk

**Pancreatic Adenocarcinoma (MSS)**
- Biology: Cold, desmoplastic, immunosuppressive
- Precedent: Checkpoint refractory
- Strategy: Requires priming (vaccine, OV, radiation)
- Risk: Fundamentally immune-cold

**Colorectal (MSS)**
- Biology: Cold, stromal barriers
- Precedent: No checkpoint benefit
- Strategy: Combination with immune priming
- Risk: Large unmet need but difficult biology

## Key Data Resources

**Essential Databases:**
- **TCGA PanCancer:** https://portal.gdc.cancer.gov (immune estimates, subtypes)
- **TISCH:** http://tisch.comp-genomics.org (single-cell TME)
- **TIMER2.0:** http://timer.cistrome.org (immune infiltration)
- **MSigDB:** https://www.gsea-msigdb.org (pathway gene sets)
- **ClinicalTrials.gov:** https://clinicaltrials.gov/api (trial data)
- **SEER:** https://seer.cancer.gov (epidemiology)

**Competitive Intelligence:**
- **Google Patents:** https://patents.google.com (patent landscape)
- **PatentScope (WIPO):** https://patentscope.wipo.int (international patents)
- **FierceBiotech:** https://www.fiercebiotech.com (industry news, deals)
- **Endpoints News:** https://endpts.com (clinical trial results, failures)
- **FDA Approvals:** https://www.fda.gov/drugs (regulatory decisions)

**Analysis Tools:**
- Immune deconvolution: CIBERSORT, xCell, TIMER
- Pathway scoring: ssGSEA (GSVA package in R)
- Cell state: Gene signature scoring (Seurat, Scanpy)

## Common Patterns

### Pattern 1: IL-2/IL-15 Family Cytokines (CD8/NK Expansion)

**Prioritize:**
- Hot tumors with progenitor exhausted T cells
- Melanoma, RCC, MSI-H tumors
- C2 (IFN-γ) and C3 (inflammatory) archetypes

**Avoid:**
- Completely cold tumors (pancreatic, CRC-MSS)
- Terminal exhaustion >50% of T cells
- C4/C5 archetypes without priming strategy

### Pattern 2: IL-12 Family (Th1 Polarization, IFN-γ)

**Prioritize:**
- Tumors with DC/APC presence but suppressed Th1
- Subset of NSCLC, ovarian with DC infiltration
- Low IFN-γ signature despite immune cells

**Avoid:**
- Th2-dominant tumors
- Inflammatory toxicity-prone populations

### Pattern 3: IL-21 (TFH, B Cell Activation)

**Prioritize:**
- Tumors with tertiary lymphoid structures (TLS)
- NSCLC with TLS, melanoma, sarcoma subsets
- B cell-inflamed TME

**Avoid:**
- B cell-poor tumors
- Lack of organized lymphoid structures

### Pattern 4: Type I IFN (STING, Innate Activation)

**Prioritize:**
- STING pathway-intact tumors
- TNBC, subset melanoma, HNSCC
- Low baseline IFN signature (room to activate)

**Avoid:**
- IFN pathway mutations (JAK1/2, STAT1)
- Constitutively high IFN (diminishing returns)

## Sensitivity Analysis

Test scoring robustness across scenarios:

```python
scenarios = {
    'biology_first': {'bio': 0.60, 'clin': 0.25, 'comm': 0.15},
    'balanced': {'bio': 0.40, 'clin': 0.35, 'comm': 0.25},
    'commercial': {'bio': 0.30, 'clin': 0.30, 'comm': 0.40},
    'de_risk': {'bio': 0.35, 'clin': 0.50, 'comm': 0.15}
}

# Identify stable leads (top 3 across all scenarios)
for scenario, weights in scenarios.items():
    rank_indications(weights)
    
stable_leads = indications_in_top3_all_scenarios()
```

**Interpretation:**
- Stable across scenarios → High confidence lead
- Scenario-dependent → Clarify strategic priorities
- Large rank variance → Controversial, needs deep dive

## Common Pitfalls to Avoid

**Biological:**
- Chasing large markets without MOA fit
- Ignoring cell state (abundance ≠ functionality)
- Overlooking pathway suppression (SOCS, TGF-β)
- Assuming all "hot" tumors are equally responsive

**Clinical:**
- Insufficient checkpoint precedent (<10% ORR = risky)
- Ignoring patient population characteristics (age, PS)
- Underestimating competitive benchmark
- No clear biomarker strategy for heterogeneous indications

**Commercial:**
- Overestimating addressable population (eligibility matters)
- Ignoring treatment sequence realities
- Misjudging competition intensity
- Unrealistic market share assumptions

**Competitive Intelligence:**
- Ignoring patent landscape (late-stage FTO issues costly)
- Not learning from competitors' failures (repeat mistakes)
- Underestimating regulatory bar set by recent approvals
- Missing white space opportunities (underexplored combinations/indications)

## Go/No-Go Criteria

**Minimum Thresholds (Must Meet ALL):**
- Biological: ≥0.50 (Plausible MOA alignment)
- Clinical: ≥0.40 (Feasible to test)
- Commercial: ≥0.35 (Sufficient opportunity)

**Red Flags (Auto-Exclude):**
- Checkpoint ORR <5% (no immune biology)
- Pathway-deficient (receptor/JAK/STAT mutations)
- Terminal exhaustion >70% of T cells
- Annual addressable population <500 patients
- Super-competitive with 5+ approved IO combinations

## Output Format

When completing indication selection analysis, provide:

1. **Executive Summary Table:**
```
Rank  Indication    Bio   Clin  Comm  Comp  Final  Recommendation
1     Melanoma     0.85  0.72  0.68  0.60  0.72   Lead
2     RCC          0.78  0.80  0.55  0.70  0.71   Backup #1
3     MSI-H        0.82  0.65  0.60  0.55  0.67   Backup #2
```

2. **Top 3 Evidence Packages:** Full profiles per template above

3. **Competitive Landscape Summary:**
   - Active programs per indication
   - Patent landscape assessment
   - Key recent failures and lessons
   - Differentiation strategy

4. **Development Roadmap:** Phase 1b/2 design for lead indication

5. **Risk Registry:** Key risks with mitigation strategies

6. **Data Gaps:** Missing analyses that would refine decision
