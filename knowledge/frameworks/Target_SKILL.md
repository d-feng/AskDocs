# Target Framework Skill

## Purpose
This skill provides a systematic framework for analyzing therapeutic targets in cancer immunotherapy. Use this when evaluating new targets, designing MOA landscapes, or assessing competitive positioning for drug development programs.

---

## Core Framework Structure

For each target, document the following dimensions:

### 1. **Target Identity & Biology**
- **Target name & aliases**: Official gene symbol, protein name, common synonyms
- **Target class**: Receptor, checkpoint, transcription factor, ion channel, enzyme, etc.
- **Tissue/cell expression**: Primary cell types expressing the target (T cells, NK cells, macrophages, tumor cells, etc.)
- **Normal physiological role**: What the target does in healthy tissue
- **Role in cancer/immunity**: How the target contributes to immune suppression, tumor progression, or therapeutic resistance

**REMINDER**: Always check expression databases (TCGA, HPA, ImmGen) to validate cell-type specificity. Broad expression may indicate on-target/off-tumor toxicity risks.

### 2. **Mechanism of Action (MOA)**
- **Primary mechanism**: How modulating this target affects anti-tumor immunity
  - Examples: "Enhances T-cell activation", "Blocks immunosuppressive signaling", "Promotes NK cell cytotoxicity"
- **Downstream effects**: Key pathways and cellular outcomes
- **Predicted synergies**: Which other therapies might combine well (checkpoint inhibitors, cytokines, ADCs, etc.)
- **Mechanistic differentiation**: How this MOA differs from existing checkpoint inhibitors

**REMINDER**: MOA must be mechanistically justified, not just descriptive. Ask "What is the specific molecular event that changes immune function?" Avoid vague statements like "modulates immunity"—specify receptor-ligand interactions, signaling cascades, or transcriptional programs affected.

### 3. **Therapeutic Modality**
- **Modality options**: 
  - Small molecule inhibitor/agonist
  - Monoclonal antibody (blocking, agonist, depleting)
  - Bispecific antibody
  - ADC (antibody-drug conjugate)
  - Cell therapy (CAR-T, engineered TCR, NK cells)
  - siRNA/ASO
  - Gene therapy
  - Fusion protein
  - Prodrug
- **Preferred modality rationale**: Why this modality fits the target biology
- **Delivery considerations**: Systemic vs local, tumor-activated, controlled release

**REMINDER**: Modality selection must match target biology:
- **Intracellular targets** → small molecules, siRNA, cell therapy with intracellular payloads
- **Cell surface receptors** → antibodies, ADCs, bispecifics
- **Secreted proteins** → antibodies, traps, fusion proteins
- **Ion channels/transporters** → small molecules (typically)
- **Transcription factors** → degraders, siRNA, or indirect pathway modulators

**REMINDER**: Consider PK/PD requirements. Agonist antibodies need FcR binding for clustering; blocking antibodies often need high affinity and long half-life; small molecules allow oral dosing but may have off-target effects.

### 4. **Direction of Activity**
- **Inhibition**: Blocking target function
  - Use when: Target mediates immunosuppression, promotes tumor survival, inhibits effector cells
  - Examples: PIEZO1 inhibition, TOX blockade, PTPRT inhibition
- **Activation/Agonism**: Enhancing target function
  - Use when: Target promotes immune activation, enhances cytotoxicity
  - Examples: 4-1BB agonism, OX40 agonism, CD40 activation
- **Depletion**: Removing cells expressing the target
  - Use when: Target marks suppressive cell populations (Tregs, MDSCs)
- **Dual/Context-dependent**: Different effects in different contexts

**REMINDER**: Direction is NOT arbitrary—it flows from target biology:
- If the target **inhibits** immune cells → **inhibit** the target (remove the brake)
- If the target **activates** immune cells → **activate** the target (push the accelerator)
- If the target **marks** suppressive cells → **deplete** cells expressing it

**REMINDER**: Watch for context-dependent targets (e.g., CD40 can activate or exhaust depending on dose/schedule; TGF-β has pro- and anti-tumor roles). Flag these for careful clinical design.

### 5. **Target Cell Type Focus**

#### T cells
- Activation state affected (naïve, effector, exhausted, memory)
- Subset specificity (CD8+, CD4+, Tregs)
- Functional outcomes (proliferation, cytokine production, cytotoxicity, persistence)

#### NK cells
- Activation/inhibition balance
- Cytotoxicity enhancement
- ADCC potential

#### Myeloid cells
- Macrophage repolarization (M1 vs M2)
- MDSC targeting
- Dendritic cell maturation

#### Tumor cells
- Direct targeting (death, growth inhibition)
- Indirect (reducing immunosuppressive signals)

**REMINDER**: Cell type specificity is critical for safety and efficacy:
- **T-cell specific** targets generally safer but may miss NK/myeloid contributions
- **Broadly expressed** targets (T, NK, myeloid) may have greater efficacy but higher toxicity risk
- **Tumor-selective** expression is rare—validate with tissue expression data

**REMINDER**: Consider cell states, not just types. A target on exhausted CD8+ T cells has different implications than one on effector CD8+ cells. Use scRNA-seq datasets to understand state-specific expression.

### 6. **Biomarker Potential**
- **Predictive**: Does target expression predict therapy response?
- **Prognostic**: Does expression correlate with outcomes?
- **Pharmacodynamic**: Can target modulation be measured?
- **Patient selection**: Can expression guide trial enrollment?

**REMINDER**: Biomarker strategy should be defined pre-clinically:
- **Predictive biomarkers** enable precision medicine—prioritize if target has variable expression
- **PD biomarkers** (target engagement, pathway modulation) are essential for dose selection
- Plan assays early: IHC for tissue, flow for blood, ELISA for soluble markers

**REMINDER**: Low expression as a biomarker (e.g., PTPRT low predicting checkpoint response) is valid but requires robust assay development. Negative selection is harder than positive selection in clinical practice.

### 7. **Clinical Development Considerations**
- **Monotherapy potential**: Likely efficacy as single agent
- **Combination rationale**: Which combinations are scientifically justified
  - With checkpoint inhibitors (PD-1/L1, CTLA-4)
  - With cytokines (IL-15, IL-12, etc.)
  - With targeted therapies
  - With chemotherapy
  - Sequencing vs simultaneous
- **Indication fit**: Which tumor types are most promising
  - Based on target expression
  - Based on immunogenic context
  - Based on unmet need
- **Safety considerations**: On-target/off-tumor toxicity risks

**REMINDER**: Combination rationale must be mechanistic, not empirical. Ask:
- Do the MOAs address different resistance mechanisms?
- Is there biological synergy (e.g., checkpoint removes brake + cytokine provides gas)?
- Are there overlapping toxicities that preclude combination?
- Is sequencing important (e.g., prime with cytokine, then block checkpoint)?

**REMINDER**: Indication selection requires triangulation:
- **Target expression** in tumor/TME (necessary but not sufficient)
- **Immunogenicity** of tumor type (cold tumors may not respond even with good target)
- **Unmet need** and competitive landscape
- **Feasibility** of patient identification and enrollment

**REMINDER**: Safety assessment must consider:
- **On-target/off-tumor**: Target expression in normal tissues (use HPA, GTEx)
- **Mechanism-based toxicity**: Immune activation → cytokine release, autoimmunity
- **Clinical precedent**: Similar targets or MOAs with known toxicities
- **Mitigation strategies**: Dose, schedule, patient selection, supportive care

---

## Example Applications

### Example 1: PIEZO1 (Novel Checkpoint - Ion Channel)

**Target Identity & Biology**
- **Target**: PIEZO1 (Piezo-type mechanosensitive ion channel component 1)
- **Class**: Mechanosensitive ion channel
- **Expression**: Broadly expressed; immune checkpoint function discovered in T cells
- **Normal role**: Mechanosensation, cellular response to physical forces
- **Cancer/immunity role**: Acts as immune checkpoint suppressing T-cell function

**MOA**
- **Primary**: PIEZO1 inhibition removes mechanical checkpoint suppression, enhancing T-cell activation and cytotoxic killing
- **Downstream**: Enhanced TCR signaling, increased effector function, improved tumor infiltration
- **Synergies**: Combines with PD-1/PD-L1 inhibitors to remove multiple suppressive signals
- **Differentiation**: Novel mechanosensing checkpoint pathway distinct from receptor-based checkpoints

**Modality**
- **Preferred**: Small molecule inhibitor (ion channel, druggable with small molecules)
- **Alternative**: Antibody-based inhibitors if extracellular epitopes are accessible
- **Rationale**: Ion channels typically amenable to small molecule inhibition; oral dosing potential

**Direction**: Inhibition (blocks suppressive checkpoint function)

**Cell Type**: T cells (CD8+ effector cells primary target)

**Biomarker Potential**
- Expression levels may predict response to PIEZO1 + checkpoint combinations
- Mechanotransduction signatures in TME may be prognostic

**Clinical Strategy**
- Combination with PD-1/PD-L1 inhibitors in checkpoint-resistant tumors
- Indications: Solid tumors with mechanical stress (pancreatic, fibrotic tumors)

---

### Example 2: TOX (Transcription Factor Checkpoint)

**Target Identity & Biology**
- **Target**: TOX (Thymocyte selection-associated HMG box protein)
- **Class**: Transcription factor (HMG-box family)
- **Expression**: T cells (specifically and highly upregulated in exhausted CD8+ T cells in chronic infections and cancer); transiently expressed in activated T cells; also plays role in T-cell development in thymus
- **Normal role**: T-cell lineage commitment during thymic development; transiently expressed during acute T-cell activation
- **Cancer/immunity role**: Master regulator of CD8+ T-cell exhaustion; drives and maintains the exhausted T-cell state through epigenetic remodeling and transcriptional programming; TOX is required for exhausted T-cell formation and persistence

**MOA**
- **Primary**: TOX inhibition prevents or reverses T-cell exhaustion by blocking the transcriptional and epigenetic program that drives expression of inhibitory receptors and loss of effector function
- **Downstream**: 
  - Reduced expression of inhibitory receptors (PD-1, TIM-3, LAG-3, TIGIT, CTLA-4)
  - Increased effector function (IFN-γ, TNF-α, granzyme B production)
  - Prevention of chromatin remodeling that locks in exhaustion
  - Enhanced T-cell proliferation and survival in chronic antigen settings
  - Reduced expression of other exhaustion-associated transcription factors (Eomes, Nr4a family)
- **Synergies**: 
  - With PD-1/PD-L1 inhibitors: TOX addresses upstream exhaustion programming, PD-1 blocks downstream inhibitory signaling—complementary mechanisms
  - With CAR-T or TIL therapy: TOX knockout prevents exhaustion in engineered cells, enabling sustained anti-tumor activity
  - With TCF1 agonists: TCF1 maintains stemness/proliferative capacity, TOX removal prevents terminal exhaustion
- **Differentiation**: TOX is the master epigenetic regulator of exhaustion; blocking TOX prevents exhaustion at its source, whereas checkpoint inhibitors only block downstream signals

**Modality**
- **Preferred**: 
  - **Cell therapy-based (CAR-T, TIL)**: CRISPR knockout of TOX during manufacturing—most clinically advanced approach
  - **Small molecule degrader** (PROTAC/molecular glue): Emerging technology for degrading nuclear proteins
  - **siRNA/ASO**: Direct mRNA knockdown if delivery to T cells can be achieved
- **Alternative**: 
  - Small molecule inhibitors of TOX DNA binding (very challenging—HMG-box proteins lack deep binding pockets)
  - Inhibitors of TOX upstream regulators (calcineurin/NFAT pathway)
- **Rationale**: Intracellular nuclear target requires modalities that prevent protein production or induce degradation; cell therapy approach most feasible near-term

**Direction**: Inhibition (blocks exhaustion transcriptional program)

**Cell Type**
- **Primary**: CD8+ T cells (exhausted and exhaustion-prone states)
- **Secondary**: CD4+ T cells (may also benefit, though less data)
- **Functional outcomes**: 
  - Prevention of exhaustion phenotype formation
  - Restoration of effector function in established exhausted cells
  - Enhanced proliferation in chronic antigen settings
  - Reduced inhibitory receptor expression
  - Increased cytotoxic capacity and cytokine production
  - Improved T-cell persistence in tumors

**Biomarker Potential**
- **Predictive**: 
  - High TOX expression in tumor-infiltrating T cells predicts:
    - T-cell exhaustion and dysfunction
    - Potentially poor response to single-agent checkpoint blockade
    - Benefit from TOX-targeted approaches
  - TOX correlates with PD-1 expression and exhaustion severity
- **Prognostic**: High TOX in TILs correlates with degree of T-cell dysfunction and may predict worse outcomes in some contexts
- **Pharmacodynamic**: 
  - TOX protein levels in blood or tumor-infiltrating T cells (flow cytometry, IHC)
  - Downstream exhaustion gene signatures (RNA-seq): inhibitory receptors, effector molecules
  - Chromatin accessibility changes at TOX target loci (ATAC-seq)
  - Functional readouts: T-cell proliferation, cytokine production, cytotoxicity assays

**Clinical Strategy**
- **Monotherapy**: Unlikely to be sufficient as single agent
  - Rationale: Tumors have multiple immune escape mechanisms beyond T-cell exhaustion (immunosuppressive myeloid cells, metabolic barriers, physical exclusion)
- **Combinations**:
  - **CAR-T/TIL with TOX knockout**: Most clinically advanced—engineer out TOX during manufacturing
    - Prevents exhaustion in transferred cells
    - Enhanced persistence and function demonstrated in preclinical models
  - **PD-1/PD-L1 + TOX inhibitor**: Dual checkpoint blockade (epigenetic/transcriptional + receptor-level)
  - **CTLA-4 + TOX inhibitor**: Early priming (CTLA-4) + sustained function (TOX blockade)
  - **Tumor vaccine + TOX-knockout TILs**: Expand tumor-specific T cells, prevent their exhaustion
  - **Sequencing**: For cell therapy, knockout during manufacturing; for pharmacologic approaches, likely simultaneous with checkpoint inhibitors
- **Indications**:
  - **Priority**: 
    - Solid tumors for TOX-knockout CAR-T (where exhaustion limits current CAR-T efficacy): pancreatic, ovarian, GBM, HCC
    - Checkpoint-refractory melanoma, NSCLC (where exhaustion limits checkpoint response)
  - **Rationale**: 
    - CAR-T fails in solid tumors primarily due to exhaustion—TOX is validated driver
    - Checkpoint blockade non-responders often have deeply exhausted TILs with high TOX
  - **Biomarker selection**: High TOX in TILs (IHC) or exhaustion gene signatures (RNA-seq)
- **Safety**:
  - **On-target/off-tumor**: TOX expressed in thymus (T-cell development) and transiently in activated T cells
    - Risk in adults: Minimal concern for thymic toxicity (thymus largely involuted)
    - Risk: Potential effects on normal T-cell activation/homeostasis
    - Mitigation: TOX is dispensable for effector and memory T-cell formation; preclinical models show acceptable safety
  - **Mechanism-based**: Enhanced T-cell activation may increase autoimmunity risk
    - Risk: Immune-related adverse events similar to checkpoint inhibitors (colitis, pneumonitis, hepatitis, endocrinopathies)
    - Magnitude: Potentially greater than PD-1 alone due to more complete exhaustion reversal
    - Mitigation: Standard irAE management; corticosteroids; patient monitoring
  - **Cell therapy-specific**: TOX-knockout CAR-T may have enhanced activity and toxicity
    - Risk: Increased cytokine release syndrome (CRS), immune effector cell-associated neurotoxicity syndrome (ICANS)
    - Mitigation: Dose de-escalation studies; tocilizumab on standby; ICU monitoring
  - **Clinical precedent**: Multiple preclinical studies show TOX deletion improves anti-tumor immunity without prohibitive toxicity

**Competitive Differentiation**
- **vs. PD-1/PD-L1**: TOX is upstream master regulator driving exhaustion; PD-1 is one downstream effector. TOX inhibition may work in PD-1 refractory settings
- **vs. other checkpoints (LAG-3, TIM-3, TIGIT)**: These are surface receptors downstream of TOX; TOX controls expression of all inhibitory receptors simultaneously
- **vs. epigenetic modulators (HDAC inhibitors, etc.)**: TOX is specific to exhaustion program; broad epigenetic drugs affect many pathways with off-target effects
- **vs. NR4A transcription factors**: TOX and NR4A cooperate in driving exhaustion; both may need to be targeted for maximal effect

**Development Challenges**
- **Druggability**: Transcription factors are historically difficult to drug with small molecules
  - HMG-box DNA binding domain lacks deep pockets for small molecule binding
  - Degraders (PROTACs) are emerging solution but still early-stage technology
- **Delivery**: If using siRNA/ASO, achieving efficient delivery to T cells in vivo is challenging
  - Lipid nanoparticles target liver, not T cells
  - T-cell specific delivery vehicles in development but not yet mature
- **Cell therapy approach most feasible**: CRISPR knockout during CAR-T/TIL manufacturing bypasses delivery problem
- **Assay development**: Need robust PD biomarkers for TOX protein levels and downstream exhaustion program in clinical samples
- **Timing**: When to intervene? Early (prevent exhaustion) vs. late (reverse established exhaustion)?

**Key Validation Data**
- Multiple independent studies in Nature (2019) established TOX as master exhaustion regulator
- TOX knockout prevents exhaustion in chronic LCMV infection models
- TOX knockout enhances CAR-T efficacy in solid tumor models
- TOX expression correlates with exhaustion in human cancer TILs
- TOX is induced by calcineurin/NFAT pathway and drives chromatin remodeling at thousands of sites

---

### Example 3: IL-15 Prodrug (Combination Strategy - Cytokine Agonist)

**Target Identity & Biology**
- **Target**: IL-15 pathway (activating)
- **Class**: Cytokine agonist (prodrug format)
- **Expression**: IL-15 receptors on NK cells, CD8+ T cells, memory T cells
- **Normal role**: Homeostasis of NK and memory T cells
- **Cancer/immunity role**: Promotes NK and T-cell expansion, activation, and persistence

**MOA**
- **Primary**: Tumor-activated IL-15 selectively expands/activates NK and CD8+ T cells in TME
- **Downstream**: Enhanced cytotoxicity, improved persistence, increased IFN-γ production
- **Synergies**: With checkpoint blockade—IL-15 provides costimulation while checkpoint removes brakes
- **Differentiation**: Tumor-selective activation reduces systemic toxicity vs recombinant IL-15

**Modality**
- **Type**: Prodrug (tumor-activated IL-15)
- **Rationale**: Protease-activated design limits systemic exposure, reduces toxicity
- **Delivery**: Systemic administration with local tumor activation

**Direction**: Activation/agonism (enhances IL-15 signaling)

**Cell Type**
- **Primary**: NK cells, CD8+ T cells
- **Secondary**: Memory T-cell populations
- **Outcome**: Proliferation, activation, enhanced cytotoxic function

**Biomarker Potential**
- IL-15 receptor expression (CD122, CD132) may predict response
- Tumor protease activity as PD marker for prodrug activation

**Clinical Strategy**
- **Combination**: PD-1/PD-L1 or CTLA-4 inhibitors
- **Sequencing**: Per patent, prodrug may be given with or before checkpoint inhibitor
- **Indications**: Checkpoint-refractory tumors, NK-sensitive tumors (RCC, melanoma)
- **Safety**: Reduced systemic IL-15 toxicity (hypotension, capillary leak) due to prodrug design

---

### Example 4: Anti-HLA-G Engineered Cells (Cell Therapy Checkpoint)

**Target Identity & Biology**
- **Target**: HLA-G (Human Leukocyte Antigen-G)
- **Class**: Non-classical MHC class I molecule
- **Expression**: Tumor cells, immunosuppressive cells in TME; normally restricted to placenta
- **Normal role**: Immune tolerance during pregnancy
- **Cancer/immunity role**: Immune escape signal; inhibits NK and T-cell function

**MOA**
- **Primary**: Engineered cells secrete anti-HLA-G scFv, blocking HLA-G-mediated immunosuppression directly in TME
- **Downstream**: Restored NK/T-cell cytotoxicity, reduced immune tolerance signals
- **Synergies**: CAR-T or TCR targeting tumor antigen + HLA-G blockade for dual attack
- **Differentiation**: Local checkpoint blockade at tumor site by cell therapy itself

**Modality**
- **Type**: Cell therapy (CAR-T or engineered TCR-T/NK cells) expressing anti-HLA-G scFv
- **Rationale**: Cells traffic to tumor and locally secrete checkpoint blocker
- **Delivery**: Infusion of engineered cells (autologous or allogeneic)

**Direction**: Inhibition (blocks HLA-G checkpoint function)

**Cell Type**
- **Engineered cells**: T cells or NK cells
- **Target cells affected**: All immune cells in TME exposed to HLA-G (NK, CD8+, CD4+)
- **Outcome**: Enhanced anti-tumor activity of both engineered and endogenous immune cells

**Biomarker Potential**
- HLA-G expression on tumor cells predicts benefit
- Soluble HLA-G levels may correlate with response

**Clinical Strategy**
- **Combination**: Built into CAR-T or TCR-T design (intrinsic combination)
- **Indications**: HLA-G+ solid tumors (gynecologic cancers, melanoma, GBM)
- **Safety**: Local scFv secretion may reduce systemic checkpoint blockade toxicity

---

## Usage Guidelines

### When to Use This Framework
- Evaluating novel targets from patent literature, publications, or internal discovery
- Building competitive MOA landscapes for specific indications
- Designing combination therapy strategies
- Prioritizing targets for drug development programs
- Communicating target rationale to stakeholders

### How to Populate the Framework
1. **Start with target biology**: Understand what the target does normally and in disease
2. **Define MOA clearly**: Be specific about cellular and molecular effects
3. **Match modality to target**: Consider druggability, expression pattern, desired PK/PD
4. **Specify direction unambiguously**: Inhibit, activate, deplete, or block
5. **Identify key cell types**: Which immune and tumor cells are affected
6. **Assess biomarker opportunities**: Can the target guide patient selection or measure response?
7. **Plan clinical development**: Mono vs combo, indication selection, safety risks

**REMINDER**: Work through the framework systematically. Don't skip sections—even if a section seems "obvious," explicitly documenting it prevents assumptions and miscommunication.

### Common Patterns

**Checkpoint inhibitors** (PIEZO1, TOX, HLA-G):
- Direction: Inhibition
- Cell type: T cells, NK cells
- Modality: Antibody or small molecule (surface targets) or degraders/siRNA/cell therapy knockout (intracellular targets)
- Combination: With existing checkpoints (PD-1, CTLA-4)

**Immune activators** (IL-15 prodrug):
- Direction: Activation/agonism
- Cell type: NK cells, CD8+ T cells
- Modality: Cytokine, prodrug, fusion protein
- Combination: With checkpoint blockade

**Biomarker-guided targets** (PTPRT):
- Expression level predicts checkpoint response
- May be target and biomarker simultaneously
- Patient selection strategy built into development plan

**REMINDER**: Patterns are useful but not prescriptive. Validate each target independently—novel targets may break established patterns.

---

## Output Format

When analyzing a new target, provide a structured summary:

```
TARGET: [Name]
CLASS: [Target type]
CELL EXPRESSION: [Primary cell types]

MOA: [Mechanism of action in 1-2 sentences]

MODALITY: [Preferred approach]
DIRECTION: [Inhibit/Activate/Deplete]

TARGET CELLS: [Which immune/tumor cells affected]
FUNCTIONAL OUTCOME: [What changes in cell behavior]

BIOMARKER POTENTIAL: [Predictive/prognostic value]

CLINICAL STRATEGY:
- Monotherapy: [Yes/No + rationale]
- Combinations: [Key partners]
- Indications: [Priority tumor types]
- Safety: [Key risks]

COMPETITIVE DIFFERENTIATION: [How this differs from existing approaches]
```

---

## Critical Reminders

### General Principles
- **Always specify cell type(s)**: T cell, NK cell, macrophage, tumor cell—be explicit. "Immune cells" is too vague.
- **Direction matters**: Inhibition vs activation changes everything about drug design, safety profile, and clinical strategy.
- **Modality follows biology**: Match the therapeutic format to target accessibility, druggability, and desired pharmacology.
- **MOA must be mechanistic**: Specify molecular events, not just phenotypic outcomes. "Enhances immunity" is insufficient; "Blocks PIEZO1-mediated Ca2+ influx, preventing T-cell inactivation" is correct.

### Target Biology
- **Validate expression claims**: Use public databases (TCGA, HPA, ImmGen) to confirm cell-type specificity. Patents may overstate selectivity.
- **Understand normal function**: On-target/off-tumor toxicity comes from hitting the target in normal tissues. If you don't know what the target does normally, you can't predict safety.
- **Consider redundancy**: Highly redundant targets (multiple family members with overlapping function) may require multi-target approaches or may have limited efficacy.

### Mechanism of Action
- **Be specific about downstream effects**: "Activates T cells" → Which T-cell subsets? What functional changes (cytotoxicity, proliferation, cytokine production)? Through which signaling pathways?
- **Synergy requires complementary MOAs**: Don't combine targets with identical MOAs. Synergy comes from addressing orthogonal resistance mechanisms.
- **Differentiation is competitive positioning**: Clearly articulate why this MOA is better than, or complementary to, existing approaches. "Another checkpoint" is not a strategy.

### Modality Selection
- **Druggability constrains modality**: Not all targets are antibody-accessible (intracellular), not all are small-molecule-tractable (large protein-protein interfaces).
- **PK/PD drives modality choice**: Need sustained target coverage? → mAb. Need pulsatile signaling? → small molecule. Need tumor selectivity? → prodrug or ADC.
- **Consider developability**: Some modalities (bispecifics, ADCs, cell therapy) have higher technical risk. Balance innovation with feasibility.

### Direction of Activity
- **Direction flows from biology**: If unsure whether to inhibit or activate, return to "What does this target do to immune cells?" If it suppresses them, inhibit the target. If it activates them, enhance the target.
- **Context-dependent targets require careful design**: TGF-β, IL-6, TNF-α can be pro- or anti-tumor. Specify conditions where modulation is beneficial and design accordingly (dose, timing, biomarker selection).

### Cell Type Focus
- **Cell type determines efficacy and safety**: T-cell targets are well-understood but may miss important NK/myeloid biology. Broadly expressed targets may be more effective but riskier.
- **Cell state matters as much as cell type**: Exhausted T cells ≠ effector T cells ≠ memory T cells. Use scRNA-seq to understand state-specific expression and function.
- **Tumor cell expression adds complexity**: If the target is on both tumor and immune cells, consider whether depleting antibodies or ADCs are needed, and how this affects MOA.

### Biomarkers
- **Plan biomarkers early**: Retrospective biomarker development often fails. Design assays pre-clinically, validate in xenografts/syngeneics, deploy in Phase 1.
- **Predictive biomarkers enable precision medicine**: If target expression varies >10-fold across patients, a biomarker-selected trial may be necessary.
- **PD biomarkers are dose-finding tools**: Measuring target engagement, pathway modulation, or immune activation guides dose selection and proves MOA.

### Clinical Development
- **Combination rationale must be scientific**: "Might work together" is not a strategy. Define the specific resistance mechanisms addressed by each agent and why they're complementary.
- **Indication selection is multifactorial**: Don't choose indications based solely on target expression. Consider: (1) Immunogenic context (hot vs cold), (2) Standard of care (unmet need), (3) Competitive landscape, (4) Feasibility (biomarker-selected enrollment).
- **Safety is predictable**: Most toxicities come from: (1) On-target/off-tumor (target in normal tissues), (2) Mechanism-based (e.g., cytokine release from immune activation), (3) Class effects (all checkpoints → autoimmunity). Use preclinical expression data and clinical precedent to predict.
- **Sequencing matters for combinations**: Some combinations require specific timing (e.g., IL-15 to expand T cells before checkpoint blockade, or PAR2 inhibition before checkpoint inhibitor). Define this based on MOA.

### Documentation
- **Be quantitative where possible**: "High expression" → provide fold-change or TPM values. "Strong synergy" → provide combination index or fold-enhancement.
- **Cite evidence**: Link to databases, publications, or internal data supporting claims.
- **Flag uncertainties**: If target biology is incompletely understood, if modality selection is uncertain, or if safety risks are unknown, document these explicitly.

### Common Pitfalls to Avoid
- ❌ Assuming broad expression is automatically a problem (may be fine if target is only functional in specific contexts)
- ❌ Choosing modality before understanding target biology (modality follows from target characteristics)
- ❌ Proposing combinations without mechanistic rationale ("synergy" is not a mechanism)
- ❌ Ignoring normal tissue expression (this is where toxicity comes from)
- ❌ Confusing correlation with causation in biomarker claims (validate functional role)
- ❌ Overlooking developability (some targets are scientifically sound but undruggable with current technology)

---

**FINAL REMINDER**: This framework is a thinking tool, not a checkbox exercise. The goal is to develop a deep, mechanistic understanding of how modulating a target will affect anti-tumor immunity, what the optimal therapeutic approach is, and how to translate this into effective clinical development. When in doubt, return to first principles: What does the target do biologically? How does modulating it change immune function? What's the best way to drug it? What are the risks? What's the clinical path forward?
