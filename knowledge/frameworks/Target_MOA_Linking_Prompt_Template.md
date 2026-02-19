# Reusable Prompt: Target-MOA Linkage with Comprehensive Literature Evidence

## Purpose
Use this prompt to systematically link therapeutic targets to immunotherapy resistance mechanisms with comprehensive literature evidence. This template structures the analysis to include: direct tumor effects, immunogenic cell death, TME remodeling, mouse model data, and failed clinical attempts.

---

## PROMPT TEMPLATE

```
I want to propose a therapeutic agent targeting [TARGET NAME/PATHWAY] to address immunotherapy resistance mechanisms. Please analyze this target comprehensively using the framework below.

AGENT: [Agent name, e.g., N17350, therapeutic version of neutrophil elastase]
TARGET: [Target name, e.g., ELANE - neutrophil elastase pathway]
PROPOSED MOA: [Brief description of proposed mechanism]

Please provide a comprehensive analysis including:

## SECTION 1: RESISTANCE MECHANISM MAPPING
Using the immunotherapy resistance knowledge base, identify which specific resistance mechanisms this agent addresses:
- List mechanisms by category (Tumor Intrinsic, TME, T Cell Dysfunction, etc.)
- Specify cellular context (e.g., "CAF → TME", "MDSC → Teff")
- Rank by impact (HIGH/MEDIUM/LOW)

## SECTION 2: DIRECT TUMOR CELL EFFECTS

### A. Cell Viability and Selectivity
Search literature for:
- Does the agent/target modulation directly kill tumor cells?
- What is the selectivity (cancer vs normal cells)?
- What is the dose-response relationship?
- Which cancer cell types are susceptible?
- What are the molecular determinants of sensitivity?

Provide specific studies with:
- Study citation (Authors, Journal, Year, PMID)
- Key quantitative findings (% killing, IC50, etc.)
- Mechanism of cell death
- Cancer selectivity data

### B. Immunogenic Cell Death (ICD) Assessment
Systematically evaluate if the agent induces ICD:

**Traditional ICD DAMP Markers:**
- [ ] Calreticulin (CRT) surface exposure
- [ ] ATP secretion
- [ ] HMGB1 release
- [ ] Type I interferon (IFN) production
- [ ] Heat shock proteins (HSP70/90)

**Alternative ICD Mechanisms:**
- Describe any novel cell death pathways
- Non-canonical ICD markers
- Unique molecular mechanisms

**Downstream Immune Activation:**
- [ ] Dendritic cell activation
- [ ] CD8+ T cell priming
- [ ] Immunological memory formation
- [ ] Abscopal effects (distant tumor impact)

**Evidence Requirements:**
For each ICD component, provide:
- ✅ Confirmed (with citation)
- ❓ Not reported
- ❌ Tested negative

### C. Tumor Cell Signaling Effects
Beyond cell death, what signaling pathways are affected?
- Proliferation pathways (MAPK, PI3K/AKT, etc.)
- Survival pathways (BCL-2 family, IAPs)
- Stress responses (ER stress, DNA damage, ROS)
- Metabolic changes
- Surface receptor modulation (MHC-I, checkpoint ligands)

## SECTION 3: TUMOR MICROENVIRONMENT REMODELING

### A. Extracellular Matrix (ECM) Effects
- Does the agent degrade or remodel ECM components?
- Which ECM proteins are affected? (Collagen I/III, fibronectin, laminin, hyaluronan)
- What is the evidence level? (in vitro, in vivo, mechanism)
- Impact on physical barriers to immune cell infiltration?

### B. Immune Cell Infiltration
- Does treatment increase T cell infiltration?
- Changes in CD8+ T cell numbers and localization?
- Changes in suppressive populations (Tregs, MDSCs, M2)?
- Spatial distribution changes (excluded → infiltrated)?

### C. Vascular and Stromal Effects
- Angiogenesis modulation (pro or anti)?
- Vascular normalization?
- CAF modulation?
- Chemokine/cytokine secretion changes?

### D. Metabolic TME Changes
- Nutrient availability (glucose, amino acids)
- pH normalization (lactate, adenosine)
- Oxygen tension changes

## SECTION 4: PRECLINICAL MOUSE MODEL EVIDENCE

For each mouse model, provide:

**Model Details:**
- Mouse strain and genetic background
- Tumor cell line or spontaneous model
- Implantation method (subcutaneous, orthotopic, tail vein)
- Treatment regimen (dose, schedule, route)

**Efficacy Results:**
- Primary endpoint: Tumor growth inhibition (TGI%), survival
- Quantitative results with statistics
- Time course of response

**Mechanism Confirmation:**
- Which MOA components were tested?
- Biomarker changes (IHC, flow cytometry, RNA-seq)
- TME remodeling evidence
- Immune infiltration data

**Key Mouse Models to Search:**
- Syngeneic models (MC38, CT26, B16F10, 4T1, EMT6, Pan02)
- Genetic models (MMTV-PyMT, KPC, Pten-null, LSL-Kras)
- Humanized models (PDX with human immune cells)
- Knockout models (target deletion or overexpression)

**Special Attention to:**
- Species differences (mouse vs human target biology)
- Genetic deletion phenotypes (target-/- mice)
- Compensatory mechanisms in knockouts
- Translation considerations

### Systematic Search Strategy:
Search: "[target name] tumor mouse model"
Search: "[target name] cancer preclinical"
Search: "[target name] knockout mice tumor"
Search: "[target name] tumor microenvironment mouse"

## SECTION 5: FAILED CLINICAL ATTEMPTS

### A. Direct Target Modulation Failures
Search for clinical trials that:
- Targeted the same pathway (agonists or antagonists)
- Used related molecules or drug classes
- Failed in development (terminated Phase 1/2/3)

For each failed attempt, document:
- Agent name and mechanism
- Clinical trial ID (NCT number)
- Indication(s) tested
- Phase reached and termination reason
- Key findings and why it failed
- Lessons learned for the proposed agent

### B. Opposite Strategy Analysis
CRITICAL: If clinical failures targeted INHIBITION, analyze if ACTIVATION would work (or vice versa)

Example structure:
- Failed strategy: [Inhibitor/Antagonist] of [target]
- Result: No efficacy OR toxicity
- Lesson: Inhibiting [target] removes [beneficial effect]
- Proposed strategy: [Agonist/Activator] to provide therapeutic effect
- Rationale: Opposite approach addresses why inhibition failed

### C. Related Pathway Failures
- Drugs targeting upstream/downstream of the target
- Drugs with overlapping mechanisms
- Combination attempts that failed
- Biomarker-selected trials that failed

### Systematic Search Strategy:
Search: "[target name] inhibitor clinical trial"
Search: "[target name] antagonist phase 2 terminated"
Search: "[target name] cancer treatment failure"
Search: "[drug class] clinical trial suspended"

## SECTION 6: CONTEXT-DEPENDENT EFFECTS (The Paradox Analysis)

Many targets have context-dependent roles (pro-tumor vs anti-tumor). Resolve any paradoxes:

### A. Identify Contradictory Evidence
- Studies showing pro-tumor effects
- Studies showing anti-tumor effects
- Seemingly contradictory mouse models

### B. Resolution Framework
Explain contradictions using:
- **Dose/Concentration:** Low vs high, chronic vs acute
- **Source:** Endogenous (from tumor/stroma) vs exogenous (therapeutic)
- **Timing:** Early vs late stage, before vs during treatment
- **Location:** Intratumoral vs systemic, primary vs metastatic
- **Cell Type:** Which cells express/respond to target
- **Context:** Genetic background, tumor type, immune status

### C. Summary Table

| Context | Source | Level | Effect | Mechanism | Outcome | Citation |
|---------|--------|-------|--------|-----------|---------|----------|
| Pro-tumor | [e.g., TANs] | Chronic low | Promotes | [mechanism] | ↑ Growth | [PMID] |
| Anti-tumor | Therapeutic | Acute high | Kills | [mechanism] | ↓ Tumor | [PMID] |

## SECTION 7: EVIDENCE SYNTHESIS

### A. Strength of Evidence Table

| Evidence Type | Finding | Quality | Citation |
|---------------|---------|---------|----------|
| Direct tumor killing | [Finding] | ⭐⭐⭐ (High/Med/Low) | [PMID] |
| ICD induction | [Finding] | ⭐⭐⭐ | [PMID] |
| ECM remodeling | [Finding] | ⭐⭐⭐ | [PMID] |
| Mouse model efficacy | [Finding] | ⭐⭐⭐ | [PMID] |
| Immune activation | [Finding] | ⭐⭐⭐ | [PMID] |
| TME remodeling | [Finding] | ⭐⭐⭐ | [PMID] |
| Clinical precedent | [Finding] | ⭐⭐⭐ | [PMID] |

**Quality Criteria:**
- ⭐⭐⭐ High: Published in top journal, replicated, mechanistic, in vivo confirmation
- ⭐⭐ Medium: Published, single study, in vitro or in vivo only
- ⭐ Low: Preliminary, conference abstract, not peer-reviewed

### B. Knowledge Gaps

Clearly identify what is NOT known:
- [ ] Direct tumor killing: [Known/Unknown/Contradictory]
- [ ] ICD mechanism: [Known/Unknown/Contradictory]
- [ ] TME remodeling: [Known/Unknown/Contradictory]
- [ ] Mouse model validation: [Known/Unknown/Contradictory]
- [ ] Optimal dose/schedule: [Known/Unknown/Contradictory]
- [ ] Biomarkers: [Known/Unknown/Contradictory]
- [ ] Safety profile: [Known/Unknown/Contradictory]

For each unknown, specify:
- Why it matters
- How to test it
- Priority level (Critical/Important/Nice to have)

### C. Species Translation Considerations

CRITICAL for mouse → human translation:

**Target Biology:**
- Is the target conserved between mouse and human?
- Expression level differences?
- Functional differences?
- Regulatory pathway differences?

**Immune System Differences:**
- Mouse vs human immune cell ratios
- Functional differences (e.g., neutrophil activity)
- Cytokine networks
- Checkpoint expression patterns

**Implications:**
- Will mouse models overpredict or underpredict human efficacy?
- Which models are most translatable?
- What additional studies needed to de-risk translation?

## SECTION 8: MECHANISTIC SUMMARY

### A. Multi-Mechanism MOA Diagram

Create a clear diagram showing:
```
AGENT → Target Modulation
         ↓
    [Mechanism 1: Direct Tumor Effect]
         ↓
    Tumor Cell Death (ICD)
         ↓
    DAMP Release
         ↓
    DC Activation → CD8+ T Cell Priming
    
    [Mechanism 2: TME Remodeling]
         ↓
    ECM Degradation
         ↓
    ↑ T Cell Infiltration
         ↓
    Immune Permissive TME
    
    [Mechanism 3: MDSC/TAM Modulation]
         ↓
    ↓ Immunosuppression
         ↓
    Restored Immune Function
```

### B. Resistance Mechanisms Addressed (Summary)

| Resistance Mechanism | How Agent Addresses It | Evidence Level |
|---------------------|------------------------|----------------|
| [e.g., CAF barrier] | ECM degradation | High (in vivo) |
| [e.g., MDSC suppression] | Direct modulation | Medium (in vitro) |
| [e.g., Poor T cell infiltration] | Chemokine induction | High (mouse models) |

### C. Biomarker Strategy

**Predictive Biomarkers (Patient Selection):**
- Which patients will respond?
- What tumor/TME features predict benefit?
- What assays are needed?

**Pharmacodynamic Biomarkers (Mechanism Confirmation):**
- On-treatment biopsies: What to measure?
- Blood biomarkers: What to track?
- Imaging biomarkers: What to visualize?

## SECTION 9: PRIORITY SCORING

### Druggability Assessment

| Parameter | Score (1-10) | Justification |
|-----------|--------------|---------------|
| Target Validation | | Genetic/pharmacologic evidence |
| Structural Feasibility | | Can we make a drug? |
| Target Accessibility | | Can drug reach target? |
| Selectivity Potential | | On-target vs off-target risk |
| Safety Precedent | | Related drugs' safety |
| Clinical Translatability | | Mouse → human likelihood |

### Resistance Mechanisms Impact

| Mechanism Category | # Mechanisms Addressed | Impact Level | Priority |
|--------------------|----------------------|--------------|----------|
| Tumor Intrinsic | X | High/Med/Low | High/Med/Low |
| TME Suppression | X | High/Med/Low | High/Med/Low |
| T Cell Dysfunction | X | High/Med/Low | High/Med/Low |
| Other | X | High/Med/Low | High/Med/Low |

### Overall Priority Score: X/10

**Scoring Rubric:**
- 9-10: Breakthrough potential, strong evidence, high unmet need
- 7-8: Strong evidence, validated mechanism, good precedent
- 5-6: Moderate evidence, some validation, needs more data
- 3-4: Weak evidence, high risk, significant unknowns
- 1-2: Insufficient evidence, high risk, poor precedent

**Priority Justification:**
[2-3 sentences explaining the overall score and key decision factors]

---

## SECTION 10: LITERATURE SEARCH CHECKLIST

Use this checklist to ensure comprehensive evidence gathering:

### Direct Tumor Effects:
- [ ] Searched: "[target] cancer cell killing"
- [ ] Searched: "[target] tumor cell viability"
- [ ] Searched: "[target] apoptosis cancer"
- [ ] Searched: "[target] cytotoxicity"

### Immunogenic Cell Death:
- [ ] Searched: "[target] immunogenic cell death"
- [ ] Searched: "[target] calreticulin HMGB1"
- [ ] Searched: "[target] CD8 T cell activation"
- [ ] Searched: "[target] dendritic cell"

### TME Remodeling:
- [ ] Searched: "[target] tumor microenvironment"
- [ ] Searched: "[target] extracellular matrix"
- [ ] Searched: "[target] T cell infiltration"
- [ ] Searched: "[target] collagen degradation"

### Mouse Models:
- [ ] Searched: "[target] tumor mouse model"
- [ ] Searched: "[target] knockout mice cancer"
- [ ] Searched: "[target] preclinical efficacy"
- [ ] Searched: "[target] syngeneic model"

### Clinical Failures:
- [ ] Searched: "[target] inhibitor clinical trial"
- [ ] Searched: "[target] phase 2 terminated"
- [ ] Searched: "[drug name] discontinued"
- [ ] Searched ClinicalTrials.gov for target

### Mechanism:
- [ ] Searched: "[target] mechanism of action"
- [ ] Searched: "[target] signaling pathway"
- [ ] Searched: "[target] downstream effects"
- [ ] Searched: "[target] substrate specificity"

---

## OUTPUT FORMAT

Please structure the analysis as follows:

### EXECUTIVE SUMMARY (1 page)
- Target and agent description
- Key resistance mechanisms addressed
- Strength of evidence (High/Medium/Low for each category)
- Priority score and rationale
- Top 3 strengths
- Top 3 concerns
- Go/No-Go recommendation

### DETAILED ANALYSIS (Sections 1-9 above)
- Full literature evidence
- All citations with PMIDs
- Comprehensive tables
- Mechanistic diagrams

### CRITICAL QUESTIONS TO ANSWER
At minimum, this analysis must definitively answer:
1. Does the agent directly kill tumor cells? (Yes/No + evidence)
2. Is the killing immunogenic? (Yes/No/Unknown + ICD markers)
3. Does it remodel the TME? (Yes/No + specific changes)
4. What mouse model evidence exists? (List models + results)
5. Have similar approaches failed clinically? (Yes/No + why)
6. What is the paradox and how is it resolved? (If applicable)
7. Are there species differences that affect translation? (Yes/No + details)
8. What is the overall priority score? (X/10 + justification)

---

## EXAMPLE USAGE

To use this prompt, fill in the placeholders:

AGENT: N17350 (therapeutic version of neutrophil elastase)
TARGET: ELANE - neutrophil elastase pathway
PROPOSED MOA: Engineered NE variant that selectively kills cancer cells via CD95 cleavage, induces immunogenic cell death, and remodels ECM barriers

[Then paste the entire prompt structure above and let the LLM/search tools work through each section systematically]

```

---

## NOTES FOR REPEATED USE

1. **Always use web search** for each literature search checklist item
2. **Document negative results** - "searched but found no evidence" is valuable
3. **Date your analysis** - literature is constantly updating
4. **Version your findings** - track when new evidence changes conclusions
5. **Cross-reference** - if multiple targets are related, link analyses together
6. **Update regularly** - re-run analysis when new studies published

---

## QUALITY CONTROL

Before finalizing, verify:
- [ ] All PMIDs are real and cited correctly
- [ ] Quantitative data includes actual numbers (not just "increased")
- [ ] Mouse strain and tumor models are specified precisely
- [ ] Clinical trial NCT numbers are verified
- [ ] Contradictory evidence is acknowledged and explained
- [ ] Species differences are explicitly addressed
- [ ] Priority score matches evidence strength
- [ ] Knowledge gaps are honestly reported

---

**Template Version:** 1.0  
**Created:** December 2024  
**Purpose:** Systematic target-MOA linkage with comprehensive literature evidence  
**Use Case:** Drug discovery, target validation, investment decisions, IND-enabling study planning
