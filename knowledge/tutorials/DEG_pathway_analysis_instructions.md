# DEG Pathway Analysis Instructions for Claude

## Purpose
This document provides step-by-step instructions for analyzing differential expression gene (DEG) tables and systematically discovering biological pathways using a hierarchical approach.

## Step 1: Filter Significant Hits

**Input**: DEG table with gene names, fold changes, and p-values

**Filtering Criteria**:
- **p-value**: < 0.05 (or adjusted p-value if available)
- **Absolute fold change**: ≥ 1.5 (log2FC ≥ 0.585 or ≤ -0.585)

**Action**:
```
1. Filter genes meeting BOTH criteria
2. Separate into upregulated (FC > 1.5) and downregulated (FC < -1.5)
3. Count total significant hits
4. Report: "Found [N] upregulated and [M] downregulated genes"
```

## Step 2: Individual Gene Pathway Search

**For each significant gene**:
1. Search gene function and known biological roles
2. Identify which pathways the gene participates in
3. Note if the gene is a key regulator or marker

**Search Strategy**:
- Use PubMed search: "[gene name] pathway function"
- Use PubMed search: "[gene name] biological process"
- Use PubMed search: "[gene name] role cancer" (if relevant)
- Supplement with: Gene Ontology, KEGG, Reactome databases when needed

**PubMed Search Best Practices**:
- For genes with many publications, add context: "[gene name] cancer immunity"
- Look for review articles: "[gene name] review" to get comprehensive overview
- Check for functional studies: "[gene name] function mechanism"
- For unclear genes: "[gene name] expression signaling pathway"
- Alternative query: "[gene name] AND (pathway OR signaling OR function)"

## Step 3: Hierarchical Pathway Organization

Map each gene to the **hierarchical pathway tree** below. A single gene can map to multiple pathways.

### HIGH-LEVEL PATHWAY CATEGORIES

#### 1. IMMUNE SYSTEM
- **Immune Effectors**
  - Cytotoxic molecules (granzyme A/B/K, perforin, granulysin)
  - Cytokines (IFNγ, TNFα, IL-2, IL-12, IL-15, etc.)
  - Chemokines (CCL5, CXCL9, CXCL10, etc.)

- **Antigen Presentation**
  - MHC Class I (HLA-A, HLA-B, HLA-C, B2M, TAP1/2)
  - MHC Class II (HLA-DR, HLA-DQ, HLA-DP, CIITA)
  - Co-stimulatory molecules (CD80, CD86, CD40)

- **Immune Regulation**
  - Checkpoint molecules (PD-1, PD-L1, CTLA-4, LAG3, TIM3, TIGIT)
  - Immunosuppressive signals (IDO1, ARG1, CD39, CD73)
  - Regulatory factors (FOXP3, IL-10, TGFβ)

- **Inflammation**
  - Acute inflammation (IL-1, IL-6, IL-8, COX2/PTGS2)
  - Chronic inflammation (TNF signaling, NF-κB pathway)
  - Inflammasome (NLRP3, caspase-1, IL-1β)

- **Immune Cell Types**
  - T cell markers (CD3, CD4, CD8, CD25, GZMB)
  - B cell markers (CD19, CD20, immunoglobulins)
  - Myeloid markers (CD11b, CD68, CD163, CD206)
  - NK cell markers (NCAM1/CD56, NKG2D, KIRs)
  - Dendritic cell markers (CD11c, CD141, CD1c)

#### 2. PROLIFERATION
- **Cell Cycle Regulation**
  - G1/S transition (CDK4/6, cyclin D, RB1, E2F)
  - G2/M transition (CDK1, cyclin B, PLK1, Aurora kinases)
  - Checkpoints (TP53, ATM, ATR, CHK1/2)

- **DNA Replication**
  - DNA synthesis (PCNA, MCM2-7, DNA polymerases)
  - Replication licensing (CDC6, CDT1, ORC)

- **Mitotic Machinery**
  - Spindle assembly (KIF11, KIF23, TPX2)
  - Centrosome (PLK4, CEP proteins)
  - Chromosome segregation (BUB1, MAD2, separins)

- **Growth Signaling**
  - MAPK/ERK pathway (RAS, RAF, MEK, ERK)
  - PI3K/AKT/mTOR pathway
  - JAK/STAT pathway
  - MYC signaling

#### 3. CELL DEATH
- **Apoptosis**
  - Intrinsic pathway (BAX, BAK, BCL2, cytochrome c, APAF1)
  - Extrinsic pathway (FAS, FASL, TRAIL, DR4/5, caspase-8)
  - Execution (caspase-3/7/9, PARP cleavage)

- **Necroptosis**
  - RIPK1/RIPK3 signaling
  - MLKL execution

- **Pyroptosis**
  - Gasdermin D (GSDMD)
  - Inflammasome activation
  - Caspase-1/11

- **Ferroptosis**
  - Lipid peroxidation (GPX4, SLC7A11/xCT)
  - Iron metabolism (TFRC, FTH1, FTL)

- **Autophagy-Dependent Cell Death**
  - Excessive autophagy leading to death

#### 4. DIFFERENTIATION
- **Stem Cell Maintenance**
  - Pluripotency factors (OCT4, SOX2, NANOG)
  - Stemness markers (CD44, CD133, ALDH)

- **Lineage Commitment**
  - T cell differentiation (TBET, GATA3, RORC, FOXP3)
  - Myeloid differentiation (PU.1, CEBPA, CEBPB)
  - Epithelial differentiation (KRT5/14, KRT8/18)

- **Terminal Differentiation**
  - Effector differentiation markers
  - Senescence markers (p16, p21, SA-βgal)

#### 5. HYPOXIA
- **Hypoxia Response**
  - HIF-1α/HIF-2α stabilization
  - HIF target genes (VEGF, GLUT1, LDHA, PDK1, CA9)

- **Angiogenesis**
  - VEGF signaling (VEGFA, VEGFR2, NRP1)
  - Angiopoietin signaling (ANGPT1/2, TIE2)
  - Endothelial markers (CD31, VWF, CDH5)

- **Metabolic Adaptation to Hypoxia**
  - Glycolysis shift
  - pH regulation

#### 6. EPITHELIAL-MESENCHYMAL TRANSITION (EMT)
- **EMT Transcription Factors**
  - SNAI1/2 (Snail/Slug)
  - TWIST1/2
  - ZEB1/2

- **Epithelial Markers** (loss in EMT)
  - E-cadherin (CDH1)
  - Claudins, occludins
  - Cytokeratins

- **Mesenchymal Markers** (gain in EMT)
  - N-cadherin (CDH2)
  - Vimentin (VIM)
  - Fibronectin (FN1)

- **EMT-Related Processes**
  - Invasion and migration (MMPs, integrins)
  - Cytoskeletal remodeling (actin, Rho GTPases)

#### 7. AUTOPHAGY
- **Autophagosome Formation**
  - Initiation (ULK1, ATG13, FIP200)
  - Nucleation (VPS34, BECN1)
  - Elongation (ATG5, ATG7, ATG12, LC3/MAP1LC3)

- **Selective Autophagy**
  - Mitophagy (PINK1, PARKIN, BNIP3)
  - ER-phagy (FAM134B, RTN3)
  - Xenophagy (NDP52, p62/SQSTM1)

- **Autophagy Regulation**
  - mTOR inhibition (activates autophagy)
  - AMPK activation (activates autophagy)

- **Lysosomal Function**
  - Lysosome markers (LAMP1/2)
  - Cathepsins (CTSD, CTSB, CTSL)

#### 8. METABOLISM
- **Glucose Metabolism**
  - Glycolysis (HK2, PFKFB3, PKM2, LDHA)
  - Gluconeogenesis (G6PC, PCK1)
  - Pentose phosphate pathway (G6PD, TKT)
  - Glycogen metabolism (GYS1, PYGL)

- **Lipid Metabolism**
  - Fatty acid synthesis (FASN, ACACA, ACLY)
  - Fatty acid oxidation (CPT1A, ACOX1, HADH)
  - Cholesterol synthesis (HMGCR, SQLE, DHCR7)
  - Lipid uptake (CD36, LPL, LDLR)

- **Triglyceride Metabolism**
  - Synthesis (DGAT1/2, GPAM)
  - Lipolysis (ATGL/PNPLA2, HSL/LIPE)

- **Amino Acid Metabolism**
  - Glutamine metabolism (GLS, GLUD1, GOT1/2)
  - Serine/glycine metabolism (PHGDH, PSAT1, SHMT1/2)
  - Branched-chain amino acids (BCAT1/2, BCKDH)
  - One-carbon metabolism (MTHFD1/2, MTR)

- **Ketone Metabolism**
  - Ketogenesis (HMGCS2, HMGCL, BDH1)
  - Ketolysis (OXCT1, BDH1)

- **One-Carbon Metabolism**
  - Folate cycle (DHFR, TYMS, MTHFR)
  - Methionine cycle (MAT1A, MTR, AHCY)

- **TCA Cycle & Oxidative Phosphorylation**
  - TCA enzymes (IDH1/2, OGDH, SUCLA2, MDH2)
  - ETC complexes (Complex I-V subunits)
  - ATP synthase (ATP5A1, etc.)

- **Metabolic Regulation**
  - mTOR pathway (mTOR, RAPTOR, RICTOR)
  - AMPK pathway (PRKAA1/2, STK11)
  - HIF-1α metabolic targets

#### 9. EXTRACELLULAR MATRIX (ECM) & ADHESION
- **ECM Components**
  - Collagens (COL1A1, COL3A1, COL4A1, etc.)
  - Laminins (LAMA1-5, LAMB1-3, LAMC1-3)
  - Fibronectin, vitronectin

- **ECM Remodeling**
  - Matrix metalloproteinases (MMP2, MMP9, MMP14)
  - TIMPs (TIMP1-4)
  - LOX family (LOX, LOXL1-4)

- **Adhesion Molecules**
  - Integrins (ITGA, ITGB subunits)
  - Cadherins (CDH1, CDH2)
  - Selectins, ICAMs, VCAMs

#### 10. SIGNAL TRANSDUCTION
- **Receptor Tyrosine Kinases**
  - EGFR pathway
  - HER2/ERBB2 pathway
  - PDGFR, FGFR, MET, ALK

- **WNT Signaling**
  - Canonical WNT (β-catenin, TCF/LEF, APC)
  - Non-canonical WNT

- **Notch Signaling**
  - NOTCH1-4, JAG1/2, DLL1/3/4
  - HES/HEY target genes

- **Hedgehog Signaling**
  - SHH, SMO, GLI1/2/3

- **TGF-β Signaling**
  - TGFB1-3, TGFBR1/2
  - SMAD2/3/4 (canonical)
  - SMAD1/5/8 (BMP pathway)

#### 11. STRESS RESPONSE
- **Oxidative Stress**
  - ROS generation (NOX family)
  - Antioxidant defense (SOD1/2, CAT, GPX1-4)
  - NRF2 pathway (NFE2L2, KEAP1, HO-1)

- **DNA Damage Response**
  - Damage sensing (ATM, ATR, DNA-PK)
  - Repair pathways (BRCA1/2, RAD51, XRCC, PARP1)
  - Checkpoints (CHK1/2, TP53, p21)

- **ER Stress (Unfolded Protein Response)**
  - PERK pathway (EIF2AK3, eIF2α, ATF4, CHOP)
  - IRE1 pathway (ERN1, XBP1)
  - ATF6 pathway
  - ER chaperones (HSPA5/BiP, HSP90B1)

- **Heat Shock Response**
  - Heat shock proteins (HSP70, HSP90, HSP27)
  - HSF1 activation

#### 12. CHROMATIN & EPIGENETICS
- **Histone Modifications**
  - Methyltransferases (EZH2, SETD2, KMT2A)
  - Demethylases (KDM family)
  - Acetyltransferases (KAT family, p300, CBP)
  - Deacetylases (HDAC1-11, SIRTs)

- **DNA Methylation**
  - DNMTs (DNMT1, DNMT3A/B)
  - TET enzymes (TET1/2/3)

- **Chromatin Remodeling**
  - SWI/SNF complexes (SMARCA4, ARID1A)
  - Polycomb complexes (PRC1, PRC2)

#### 13. RNA PROCESSING
- **Splicing**
  - Spliceosome components (SF3B1, U2AF1, SRSF2)
  - Alternative splicing regulators

- **RNA Modification**
  - m6A writers/readers/erasers (METTL3, YTHDF, FTO)

- **RNA Stability & Decay**
  - Decay machinery (XRN1, DCP1/2)
  - Stabilizing factors (HuR/ELAVL1)

#### 14. TRANSLATION & PROTEIN HOMEOSTASIS
- **Translation Initiation**
  - eIF factors (eIF4E, eIF4G, eIF2α)
  - mTOR regulation of translation

- **Ribosome Biogenesis**
  - Ribosomal proteins (RPS, RPL)
  - Nucleolar proteins

- **Proteasome**
  - 20S core (PSMA, PSMB)
  - 19S regulatory (PSMC, PSMD)
  - Ubiquitin ligases (E3s)

- **Chaperones**
  - HSP families (HSP70, HSP90, HSP60)
  - Co-chaperones

## Step 4: Pathway Enrichment Analysis

**After mapping genes to pathways**:

1. **Count hits per high-level category**
   - Report: "[Category] has [N] upregulated and [M] downregulated genes"

2. **Identify enriched pathways**
   - If ≥3 genes map to a high-level category, it's "enriched"
   - If ≥2 genes map to a low-level sub-pathway, it's "enriched"

3. **Calculate directional consistency**
   - Are genes in a pathway mostly upregulated or downregulated?
   - Report: "[Pathway] shows [up/down/mixed] regulation"

## Step 5: Deep Dive on Enriched Pathways

**For each ENRICHED high-level category**:

1. **Examine all low-level sub-pathways**
   - Which specific mechanisms are affected?
   - Example: If "IMMUNE SYSTEM" is enriched, check if it's driven by "Immune Effectors" vs "Immune Regulation"

2. **Identify key driver genes**
   - Which genes have highest fold changes?
   - Which are known master regulators?

3. **Check for pathway coherence**
   - Do the genes make biological sense together?
   - Are upstream regulators and downstream targets both present?

4. **Cross-pathway connections**
   - Example: EMT + ECM remodeling often co-occur
   - Example: Hypoxia + Glycolysis + Angiogenesis often linked

## Step 6: Biomni Agent Deep Dive Instructions

**When using Biomni for deeper analysis**:

```
For enriched high-level category [CATEGORY]:

1. PubMed search: "What are all known genes in [specific sub-pathway]?"
2. Check: Are there additional pathway members NOT in my DEG list?
3. PubMed search: "What regulates [pathway name] activation?"
4. PubMed search: "What are the downstream effects of [pathway name]?"
5. PubMed search: "Cross-talk between [pathway 1] and [pathway 2]"
6. PubMed search: "[pathway name] in [disease/condition context]"

For contradictory signals:
- PubMed search: "Why would [gene A] be upregulated while [gene B] is downregulated?"
- PubMed search: "Feedback loops in [pathway name]"
- PubMed search: "[gene A] [gene B] interaction regulation"
```

## Step 7: Generate Summary Report

**Output structure**:

### 1. Overview
- Total significant genes (up/down)
- Number of enriched high-level pathways

### 2. Major Pathway Changes
For each enriched pathway:
- Number of genes affected
- Direction of regulation (up/down/mixed)
- Key driver genes (top 3-5 by FC)
- Biological interpretation

### 3. Pathway Interactions
- Which pathways likely interact?
- Upstream-downstream relationships
- Feedback loops identified

### 4. Unexpected Findings
- Contradictions or surprising patterns
- Genes without clear pathway assignment
- Novel pathway combinations

### 5. Recommendations for Follow-up
- Which pathways warrant experimental validation?
- Suggested experiments
- Additional bioinformatics analyses

## Example Workflow

**Input**: DEG table with 500 genes

**Step 1**: Filter → 87 genes (58 up, 29 down) with |FC| ≥ 1.5, p < 0.05

**Step 2**: Search each gene using PubMed
- GZMB → PubMed: "GZMB granzyme B function" → Immune Effectors (cytotoxic molecules)
- HLA-A → PubMed: "HLA-A antigen presentation" → Antigen Presentation (MHC Class I)
- LDHA → PubMed: "LDHA lactate dehydrogenase pathway" → Metabolism (glycolysis)
- ... (continue for all 87)

**Step 3**: Map to hierarchy
- IMMUNE SYSTEM: 23 genes (18 up, 5 down)
  - Immune Effectors: 8 up
  - Antigen Presentation: 6 up
  - Immune Regulation: 4 down
- PROLIFERATION: 15 genes (14 up, 1 down)
- METABOLISM: 12 genes (9 up, 3 down)
  - Glucose Metabolism: 6 up (including LDHA, HK2, PFKFB3)
  - Lipid Metabolism: 3 up

**Step 4**: Enrichment
- IMMUNE SYSTEM is enriched (23 genes)
- PROLIFERATION is enriched (15 genes)
- METABOLISM is enriched (12 genes)
- Within metabolism, Glucose Metabolism is highly enriched

**Step 5**: Deep dive
- Immune System: Strong cytotoxic signature + antigen presentation UP, but some regulatory genes DOWN
- Interpretation: Activated anti-tumor immunity
- Cross-check: Are checkpoint genes up or down?

**Step 6**: Biomni PubMed searches
- PubMed: "glycolysis T cell activation metabolism"
- PubMed: "HLA upregulation granzyme cytotoxic T cell"
- PubMed: "cell proliferation immune response feedback"
- Review top 5-10 abstracts to understand mechanisms

**Step 7**: Report
- Summary: Strong immune activation signature with metabolic reprogramming toward glycolysis
- Key drivers: GZMB, IFNG, HLA-A, LDHA, HK2
- Interpretation: Likely effective anti-tumor response
- Follow-up: Validate protein levels of GZMB and HLA-A; measure lactate production

## Tips for Claude

1. **Be systematic**: Go through ALL significant genes, don't skip
2. **Use PubMed search queries per gene** - multiple searches if function is unclear
3. **Prioritize recent literature**: Focus on papers from last 5-10 years for current understanding
4. **Note ambiguous genes**: Some genes participate in multiple pathways
5. **Check gene aliases**: Same gene may have multiple names (search alternative names)
6. **Consider magnitude**: A gene with 5-fold change is more important than 1.6-fold
7. **Watch for patterns**: If 8/10 glycolysis genes are up, that's a strong signal
8. **Be honest about uncertainty**: If you can't confidently assign a gene to a pathway, say so
9. **Connect the dots**: Explain WHY certain pathways co-occur based on literature
10. **Use the tree structure**: Always start with high-level categories, then drill into sub-pathways
11. **Prioritize enriched pathways**: Don't spend equal time on all categories
12. **Cross-reference databases**: Use GeneCards, NCBI Gene, UniProt to verify function

## Common Pitfalls to Avoid

- ❌ Stopping after finding first few pathways
- ❌ Ignoring downregulated genes
- ❌ Not checking if pathway members are coordinately regulated
- ❌ Overlooking cross-pathway connections
- ❌ Treating all fold changes equally (magnitude matters!)
- ❌ Not using PubMed to search for genes you don't immediately recognize
- ❌ Relying only on gene names without literature verification
- ❌ Not checking recent reviews for updated pathway information
- ❌ Forgetting to separate high-level and low-level pathway categories
- ❌ Not using Biomni when a pathway is enriched but mechanism is unclear
- ❌ Using only single PubMed query per gene (try multiple if unclear)

## Quality Check

Before finalizing your analysis, verify:
- ✅ All significant genes have been searched using PubMed
- ✅ Each gene is mapped to at least one pathway (or marked as "unknown" with note)
- ✅ Gene pathway assignments are supported by literature evidence
- ✅ Enriched pathways are clearly identified
- ✅ Deep dive completed for all enriched high-level categories
- ✅ Biological interpretation is provided (not just gene lists)
- ✅ Key driver genes are highlighted with supporting citations
- ✅ Cross-pathway relationships are discussed with mechanistic basis
- ✅ Summary report follows the structure above
- ✅ Uncertain assignments are clearly flagged for follow-up

---

**This is a living document. Update the pathway tree as new biology is discovered.**
