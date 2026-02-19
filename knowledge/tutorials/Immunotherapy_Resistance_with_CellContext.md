# Immunotherapy Resistance Mechanisms
## Knowledge Base for BioMNI Reasoning with Cellular Context

**Document Purpose:** This knowledge base provides hierarchical organization of major immunotherapy resistance mechanisms with color-coded cellular context annotations for AI agent reasoning.

---

## 1. TUMOR INTRINSIC MECHANISMS

### 1.1 Antigen Presentation Defects

| Mechanism | Cell Context |
|-----------|--------------|
| HLA-A/B/C allele loss | **Tumor** |
| B2M (β2-microglobulin) mutations | **Tumor** |
| TAP1/TAP2 transporter deficiency | **Tumor** |
| NLRC5 downregulation | **Tumor** |
| HLA-LOH (loss of heterozygosity) | **Tumor** |
| Proteasome subunit mutations (PSMB8/9/10) | **Tumor** |
| Tapasin deficiency | **Tumor** |
| Calreticulin mutations | **Tumor** |
| ERAP1/ERAP2 dysregulation | **Tumor** |

**Neoantigen Loss:**
| Mechanism | Cell Context |
|-----------|--------------|
| Low tumor mutational burden | **Tumor** |
| Immunogenic mutation loss under immune pressure | **Tumor** |
| Clonal neoantigen depletion | **Tumor** |
| MSS phenotype with low neoantigen load | **Tumor** |

### 1.2 Immune Checkpoint Upregulation

| Mechanism | Cell Context |
|-----------|--------------|
| Constitutive PD-L1 via oncogenes (EGFR, ALK, MYC) | **Tumor** |
| IFN-γ induced adaptive PD-L1 upregulation | **Tumor** |
| 9p24.1 PD-L1 amplification/translocation | **Tumor** |
| 3'-UTR alterations stabilizing PD-L1 mRNA | **Tumor** |
| Galectin-9 expression (TIM-3 ligand) | **Tumor** |
| HVEM expression (BTLA ligand) | **Tumor** |
| CD155/CD112 engaging TIGIT | **Tumor** |
| VISTA immunosuppression | **Tumor** |

### 1.3 Oncogenic Signaling Pathways

**WNT/β-catenin Activation:**
| Mechanism | Cell Context |
|-----------|--------------|
| CTNNB1 mutations preventing T cell infiltration | **Tumor** |
| APC loss → β-catenin stabilization | **Tumor** |
| BATF3+ DC exclusion from TME | **Tumor** |
| CCL4 chemokine suppression | **Tumor** |

**MAPK Pathway:**
| Mechanism | Cell Context |
|-----------|--------------|
| BRAF V600E driving immunosuppressive cytokines | **Tumor** |
| NRAS/KRAS mutations affecting immune recruitment | **Tumor** |
| MEK1/2 hyperactivation suppressing MHC-I | **Tumor** |

**PI3K/AKT/mTOR:**
| Mechanism | Cell Context |
|-----------|--------------|
| PTEN loss → PI3K/AKT activation | **Tumor** |
| PIK3CA activating mutations | **Tumor** |
| mTOR-driven immunosuppressive metabolism | **Tumor** |

---

## 2. TUMOR MICROENVIRONMENT IMMUNOSUPPRESSION

### 2.1 Myeloid-Derived Suppressor Cells (MDSCs)

**MDSC Recruitment:**
| Mechanism | Cell Context |
|-----------|--------------|
| GM-CSF/G-CSF driving myelopoiesis | **Tumor → MDSC** |
| CCL2/CCR2 axis recruiting M-MDSCs | **Tumor → MDSC** |
| CXCL1/2/5 via CXCR2 recruiting PMN-MDSCs | **Tumor → MDSC** |
| CXCL12/CXCR4 mobilization from bone marrow | **Tumor → MDSC** |
| S100A8/A9 alarmin-mediated expansion | **MDSC** |

**MDSC Suppressive Functions:**
| Mechanism | Cell Context |
|-----------|--------------|
| ARG1 L-arginine depletion | **MDSC → Teff** |
| iNOS nitric oxide production | **MDSC → Teff** |
| NOX2 ROS generation | **MDSC → Teff** |
| Peroxynitrite TCR damage | **MDSC → Teff** |
| PD-L1 expression | **MDSC → Teff** |
| IL-10/TGF-β secretion | **MDSC → TME** |
| Treg expansion via TGF-β/retinoic acid | **MDSC → Treg** |
| Cysteine sequestration | **MDSC → Teff** |

### 2.2 Tumor-Associated Macrophages (TAMs)

**M2 Macrophage Polarization:**
| Mechanism | Cell Context |
|-----------|--------------|
| CSF-1/CSF-1R signaling | **Tumor → M2** |
| IL-4/IL-13 M2 differentiation | **TME → M2** |
| CCL2/CCR2 recruitment | **Tumor → M2** |
| Hypoxia HIF-1α/2α driving M2 program | **TME → M2** |
| Lactate via MCT1 promoting M2 polarization | **Tumor → M2** |

**TAM Suppressive Mechanisms:**
| Mechanism | Cell Context |
|-----------|--------------|
| ARG1 arginine depletion | **M2 → Teff** |
| IL-10 secretion | **M2 → TME** |
| TGF-β promoting Treg differentiation | **M2 → Treg** |
| PD-L1/PD-L2 expression | **M2 → Teff** |
| VEGF promoting angiogenesis | **M2 → TME** |
| CCL22 recruiting Tregs | **M2 → Treg** |
| Matrix remodeling creating barriers | **M2 → Teff** |
| Efferocytosis maintaining immunosuppression | **M2** |

### 2.3 Regulatory T Cells (Tregs)

**Treg Recruitment:**
| Mechanism | Cell Context |
|-----------|--------------|
| CCL22/CCR4 axis trafficking | **Tumor → Treg** |
| CCL17/CCR4 signaling | **Tumor → Treg** |
| CXCL12/CXCR4 attracting FOXP3+ Tregs | **CAF → Treg** |
| CCL28/CCR10 pathway in mucosal tumors | **Tumor → Treg** |

**Treg Immunosuppressive Mechanisms:**
| Mechanism | Cell Context |
|-----------|--------------|
| IL-10/TGF-β secretion | **Treg → Teff** |
| CTLA-4 competing for B7 ligands | **Treg → DC** |
| CD25 IL-2 consumption creating cytokine sink | **Treg → Teff** |
| CD39/CD73 generating adenosine | **Treg → Teff** |
| Granzyme/perforin cytolysis of effector T cells | **Treg → Teff** |
| LAG-3 inhibiting DC maturation | **Treg → DC** |
| FGL2 suppressing DC function | **Treg → DC** |
| Neuropilin-1 promoting Treg stability | **Treg** |

### 2.4 Cancer-Associated Fibroblasts (CAFs)

**Physical Barrier Formation:**
| Mechanism | Cell Context |
|-----------|--------------|
| Dense collagen deposition | **CAF → TME** |
| Fibronectin/laminin networks impeding T cell migration | **CAF → TME** |
| Hyaluronic acid increasing interstitial pressure | **CAF → TME** |
| FAP ECM remodeling | **CAF → TME** |

**CAF Immunosuppressive Signaling:**
| Mechanism | Cell Context |
|-----------|--------------|
| TGF-β promoting EMT and immune exclusion | **CAF → Tumor** |
| CXCL12 sequestering T cells in stroma | **CAF → Teff** |
| IL-6/IL-8 recruiting MDSCs | **CAF → MDSC** |
| PD-L1/PD-L2 expression on CAF subsets | **CAF → Teff** |
| VEGF promoting aberrant vasculature | **CAF → TME** |
| HGF driving immunosuppressive programs | **CAF → TME** |

### 2.5 Metabolic Competition and Nutrient Depletion

**Amino Acid Depletion:**
| Mechanism | Cell Context |
|-----------|--------------|
| IDO1/TDO2 tryptophan → kynurenine | **Tumor/DC → Teff** |
| ARG1/2 L-arginine depletion | **MDSC/M2 → Teff** |
| Glutamine competition | **Tumor → Teff** |
| Cysteine/cystine depletion limiting glutathione | **Tumor → Teff** |

**Glucose Metabolism Competition:**
| Mechanism | Cell Context |
|-----------|--------------|
| Warburg effect glucose depletion | **Tumor → Teff** |
| Lactate accumulation creating acidic environment | **Tumor → Teff** |
| Lactate-mediated GPR81 signaling | **Tumor → Teff** |
| MCT1/MCT4 transporters creating gradient | **Tumor** |
| Acidosis (pH <6.5) impairing cytotoxicity | **TME → Teff** |

**Adenosine Pathway:**
| Mechanism | Cell Context |
|-----------|--------------|
| CD39 converting ATP/ADP → AMP | **Treg/Tumor** |
| CD73 converting AMP → adenosine | **Treg/Tumor** |
| A2A/A2B receptor activation | **TME → Teff** |
| Adenosine-mediated cAMP elevation | **TME → Teff** |
| Hypoxia-driven CD39/CD73 upregulation | **TME** |

**Hypoxia:**
| Mechanism | Cell Context |
|-----------|--------------|
| HIF-1α stabilization driving immunosuppressive genes | **Tumor** |
| VEGF creating chaotic vasculature | **Tumor → TME** |
| PD-L1 induction by hypoxia | **Tumor/Myeloid** |
| CXCR4 upregulation recruiting immunosuppressive cells | **Tumor** |
| Adenosine accumulation via HIF-dependent CD39/CD73 | **TME** |

---

## 3. T CELL INTRINSIC DYSFUNCTION

### 3.1 T Cell Exhaustion

**Inhibitory Receptor Co-expression:**
| Mechanism | Cell Context |
|-----------|--------------|
| PD-1 (PDCD1) sustained expression | **Teff** |
| TIM-3 (HAVCR2) on severely exhausted T cells | **Teff** |
| LAG-3 (CD223) synergizing with PD-1 | **Teff** |
| TIGIT inhibiting NK and T cell function | **Teff/NK** |
| BTLA (CD272) via HVEM | **Teff** |
| CD160 contributing to exhaustion | **Teff** |
| 2B4 (CD244) causing dysfunction | **Teff/NK** |

**Transcriptional Exhaustion Programs:**
| Mechanism | Cell Context |
|-----------|--------------|
| TOX/TOX2 driving exhaustion program | **Teff** |
| NR4A family (NR4A1/2/3) promoting exhaustion | **Teff** |
| NFAT without AP-1 inducing exhaustion genes | **Teff** |
| Loss of T-bet, Eomes imbalance | **Teff** |
| BATF overexpression in terminal exhaustion | **Teff** |

**Epigenetic Exhaustion Marks:**
| Mechanism | Cell Context |
|-----------|--------------|
| DNA methylation at effector loci (IFNG, TNF) | **Teff** |
| Repressive histone marks (H3K27me3) | **Teff** |
| Chromatin remodeling creating locked state | **Teff** |
| Loss of accessibility at enhancers | **Teff** |

### 3.2 T Cell Anergy

| Mechanism | Cell Context |
|-----------|--------------|
| TCR signal 1 without co-stimulation (signal 2) | **Teff** |
| Weak TCR-pMHC interactions | **Teff** |
| Loss of CD28 co-stimulation | **Teff** |
| E3 ubiquitin ligases (GRAIL, Cbl-b, Itch) | **Teff** |
| NFAT activation without AP-1 | **Teff** |
| DGKα/ζ limiting DAG-mediated signaling | **Teff** |

### 3.3 Impaired T Cell Trafficking and Infiltration

**Chemokine Deficiency:**
| Mechanism | Cell Context |
|-----------|--------------|
| Absent CXCL9/10/11 (CXCR3 ligands) | **Tumor** |
| CCL5 (RANTES) suppression | **Tumor** |
| Loss of CCL3/CCL4 | **Tumor** |
| IFN-γ signaling defects | **Tumor** |

**Vascular and Stromal Barriers:**
| Mechanism | Cell Context |
|-----------|--------------|
| Endothelial anergy reducing adhesion molecules | **Endothelial** |
| Absent VCAM-1/ICAM-1 | **Endothelial** |
| Dense collagen network | **CAF → TME** |
| Aberrant tumor vasculature | **TME** |
| CXCL12 sequestration in stroma | **CAF → Teff** |

### 3.4 Clonal Deletion and Senescence

**Activation-Induced Cell Death:**
| Mechanism | Cell Context |
|-----------|--------------|
| Fas/FasL-mediated apoptosis | **Teff** |
| TRAIL receptor signaling | **Teff** |
| Chronic TCR stimulation | **Teff** |

**Replicative Senescence:**
| Mechanism | Cell Context |
|-----------|--------------|
| Telomere shortening | **Teff** |
| Loss of CD27/CD28 expression | **Teff** |
| CD57, KLRG1 expression | **Teff** |
| Impaired proliferative capacity | **Teff** |

---

## 4. IMMUNOSUPPRESSIVE CYTOKINE NETWORKS

### 4.1 TGF-β Signaling

| Mechanism | Cell Context |
|-----------|--------------|
| Tumor/CAF/Treg/MDSC TGF-β production | **Tumor/CAF/Treg/MDSC** |
| Integrin activation (αvβ6, αvβ8) of latent TGF-β | **Tumor/CAF** |
| SMAD2/3 suppressing cytotoxic genes | **Teff** |
| NKG2D inhibition | **NK/Teff** |
| DC maturation blockade | **DC** |
| FOXP3 Treg induction | **Treg** |
| CAF activation and collagen deposition | **CAF** |
| EMT and T cell exclusion | **Tumor → TME** |

### 4.2 IL-10 Family Cytokines

| Mechanism | Cell Context |
|-----------|--------------|
| Tumor/TAM/MDSC IL-10 secretion | **Tumor/M2/MDSC** |
| STAT3 activation downstream of IL-10R | **Multiple** |
| Suppression of MHC-II and co-stimulatory molecules | **DC** |
| Inhibition of IL-12, TNF-α, IFN-γ | **TME** |
| Induction of T cell anergy | **Teff** |
| M2 macrophage polarization | **M2** |
| IL-35 from Tregs | **Treg** |

### 4.3 Pro-tumorigenic Inflammatory Cytokines

**IL-6/STAT3 Axis:**
| Mechanism | Cell Context |
|-----------|--------------|
| Tumor/CAF IL-6 driving STAT3 | **Tumor/CAF** |
| MDSC expansion and activation | **MDSC** |
| Th17 differentiation | **T cells** |
| DC maturation inhibition | **DC** |
| Anti-apoptotic gene upregulation | **Tumor** |

**IL-23 and Th17:**
| Mechanism | Cell Context |
|-----------|--------------|
| IL-23 from myeloid cells | **Myeloid** |
| Th17 plasticity → pro-tumor phenotype | **T cells** |
| IL-17A/F promoting angiogenesis | **T cells → TME** |

### 4.4 Type 2 Cytokine Skewing

| Mechanism | Cell Context |
|-----------|--------------|
| Th2 IL-4/IL-13 production | **T cells** |
| M2 differentiation via IL-4Rα/STAT6 | **M2** |
| Suppression of Th1/IFN-γ | **TME** |
| Eosinophil recruitment | **TME** |

---

## 5. INTERFERON SIGNALING DEFECTS

### 5.1 JAK-STAT Pathway Mutations

| Mechanism | Cell Context |
|-----------|--------------|
| JAK1/JAK2 loss-of-function mutations | **Tumor** |
| STAT1 mutations preventing nuclear translocation | **Tumor** |
| Loss of MHC-I upregulation response | **Tumor** |
| Impaired ISG (interferon-stimulated gene) induction | **Tumor** |

### 5.2 Interferon Receptor Defects

| Mechanism | Cell Context |
|-----------|--------------|
| IFNGR1/IFNGR2 mutations or deletions | **Tumor** |
| IFNAR1/IFNAR2 defects | **Tumor** |
| Truncated receptors lacking signaling domains | **Tumor** |
| Dominant negative mutations | **Tumor** |

### 5.3 Downstream Effector Defects

| Mechanism | Cell Context |
|-----------|--------------|
| IRF1/3/7/8 alterations | **Tumor** |
| NLRC5 deficiency (MHC-I transactivator) | **Tumor** |
| Coordinated MHC-I machinery downregulation | **Tumor** |

### 5.4 Negative Regulators of IFN Signaling

| Mechanism | Cell Context |
|-----------|--------------|
| SOCS1/SOCS3 upregulation | **Tumor/Immune** |
| PTPN2 (TC-PTP) dephosphorylating JAK/STAT | **Tumor** |
| SHP1/SHP2 phosphatases | **Tumor/Immune** |
| PIAS proteins inhibiting STAT activity | **Tumor** |

---

## 6. DENDRITIC CELL DYSFUNCTION AND IMPAIRED PRIMING

### 6.1 DC Recruitment Defects

| Mechanism | Cell Context |
|-----------|--------------|
| Insufficient FLT3L for cDC1 development | **TME** |
| Absent CCL4 preventing BATF3+ DC infiltration | **Tumor** |
| XCL1/XCL2 deficiency | **Tumor** |
| Loss of CCR7 preventing LN migration | **DC** |

### 6.2 DC Maturation Defects

| Mechanism | Cell Context |
|-----------|--------------|
| TGF-β and IL-10 blocking maturation | **DC** |
| VEGF inhibiting NF-κB in DCs | **DC** |
| Absent CD40L co-stimulation | **T cells → DC** |
| Low CD80/CD86 expression | **DC** |
| Reduced MHC-II surface levels | **DC** |
| IL-10 secretion by tolerogenic DCs | **DC → Teff** |
| IDO1 expression generating kynurenine | **DC → Teff** |
| PD-L1/PD-L2 on immature DCs | **DC → Teff** |

### 6.3 Cross-Presentation Defects

| Mechanism | Cell Context |
|-----------|--------------|
| Defective phagocytosis of dying tumor cells | **DC** |
| Loss of calreticulin 'eat-me' signal | **Tumor** |
| CD47 'don't eat me' signal overexpression | **Tumor → DC** |
| PD-L1 inhibiting phagocytosis | **Tumor → DC** |
| SEC61 translocon deficiency | **DC** |
| WDFY4 deficiency in cDC1s | **DC** |

### 6.4 DC Subset Imbalances

| Mechanism | Cell Context |
|-----------|--------------|
| BATF3 deficiency eliminating cDC1 | **DC** |
| IRF8 mutations impairing cDC1 development | **DC** |
| Loss of XCR1+CD103+ DCs | **DC** |
| pDC dysfunction and impaired Type I IFN | **DC** |

---

## 7. STRUCTURAL AND VASCULAR IMMUNE EXCLUSION

### 7.1 Extracellular Matrix Remodeling

| Mechanism | Cell Context |
|-----------|--------------|
| Dense Type I/III collagen networks | **CAF → TME** |
| Collagen cross-linking by LOX | **CAF → TME** |
| High molecular weight hyaluronic acid | **CAF → TME** |
| Elevated interstitial fluid pressure | **TME** |
| CD44-HA immunosuppressive signaling | **Tumor/Immune** |

### 7.2 Vascular Abnormalities

| Mechanism | Cell Context |
|-----------|--------------|
| VEGF-A creating leaky, chaotic vessels | **Tumor/M2 → TME** |
| Loss of pericyte coverage | **Endothelial** |
| Tortuous vessels with poor perfusion | **TME** |
| Endothelial FasL inducing T cell apoptosis | **Endothelial → Teff** |
| Endothelial PD-L1 expression | **Endothelial → Teff** |
| ICAM-1/VCAM-1 downregulation | **Endothelial** |
| Absent high endothelial venules (HEVs) | **TME** |

### 7.3 Tertiary Lymphoid Structure Absence

| Mechanism | Cell Context |
|-----------|--------------|
| Insufficient lymphotoxin-α/β | **TME** |
| Loss of CXCL13 preventing B/TFH recruitment | **TME** |
| Absent CCL19/CCL21 | **TME** |
| TGF-β suppression of lymphoid neogenesis | **TME** |
| Loss of local T cell priming | **TME** |

---

## 8. RESISTANCE TO IMMUNE CELL CYTOTOXICITY

### 8.1 Apoptosis Resistance

| Mechanism | Cell Context |
|-----------|--------------|
| BCL-2/BCL-XL/MCL-1 overexpression | **Tumor** |
| XIAP/Survivin inhibiting caspases | **Tumor** |
| CASP8 mutations | **Tumor** |
| FADD deficiency | **Tumor** |

### 8.2 Granzyme/Perforin Resistance

| Mechanism | Cell Context |
|-----------|--------------|
| Altered membrane lipid composition | **Tumor** |
| Membrane repair mechanisms | **Tumor** |
| Serpin B9 (PI-9) inhibiting granzyme B | **Tumor** |
| Loss of granzyme substrates | **Tumor** |

### 8.3 NK Cell Evasion

| Mechanism | Cell Context |
|-----------|--------------|
| Shedding of MICA/MICB (NKG2D ligands) | **Tumor** |
| ULBP downregulation | **Tumor** |
| HLA-E upregulation engaging NKG2A | **Tumor → NK** |
| Tumor-derived HLA-E+ exosomes | **Tumor → NK** |

### 8.4 Complement Resistance

| Mechanism | Cell Context |
|-----------|--------------|
| CD55 (DAF) preventing C3 convertase | **Tumor** |
| CD46 (MCP) promoting C3b/C4b degradation | **Tumor** |
| CD59 blocking MAC formation | **Tumor** |
| Factor H recruitment | **Tumor** |

---

## 9. IMMUNOTHERAPY-SPECIFIC RESISTANCE MECHANISMS

### 9.1 Adaptive Resistance to Checkpoint Blockade

| Mechanism | Cell Context |
|-----------|--------------|
| TIM-3 upregulation after PD-1 blockade | **Teff** |
| LAG-3 compensating for PD-1 inhibition | **Teff** |
| TIGIT induction as escape | **Teff/NK** |
| VISTA/B7-H3/B7-H4 upregulation | **Tumor/Immune** |
| JAK1/JAK2 mutations under therapy | **Tumor** |
| B2M loss during treatment | **Tumor** |
| PD-L1 upregulation paradoxically conferring resistance | **Tumor** |
| IDO1 induction by IFN-γ | **Tumor/DC** |

### 9.2 CAR-T Cell Resistance

| Mechanism | Cell Context |
|-----------|--------------|
| Target antigen loss (e.g., CD19) | **Tumor** |
| Antigen-negative variants outgrowing | **Tumor** |
| Alternative splicing removing epitope | **Tumor** |
| Lineage switching (B→myeloid) | **Tumor** |
| CAR-T exhaustion in TME | **CAR-T** |
| Poor trafficking to solid tumors | **CAR-T** |
| Tonic signaling → premature differentiation | **CAR-T** |

### 9.3 Vaccine Resistance

| Mechanism | Cell Context |
|-----------|--------------|
| Epitope spreading failure | **TME** |
| Insufficient antigen release | **Tumor** |
| Defective DC uptake | **DC** |
| Suboptimal adjuvant | **Vaccine** |
| Treg expansion post-vaccination | **Treg** |
| MDSC mobilization | **MDSC** |

### 9.4 Cytokine Therapy Resistance

| Mechanism | Cell Context |
|-----------|--------------|
| IL-2: Preferential Treg expansion via CD25 | **Treg** |
| IL-2: Vascular leak syndrome | **Systemic** |
| IFN-α: JAK-STAT pathway mutations | **Tumor** |
| IFN-α: SOCS upregulation | **Tumor/Immune** |
| Chronic IFN causing T cell exhaustion | **Teff** |

---

## 10. MICROBIOME AND SYSTEMIC FACTORS

### 10.1 Gut Microbiome Dysbiosis

| Mechanism | Cell Context |
|-----------|--------------|
| Lack of Bifidobacterium/Akkermansia/Faecalibacterium | **Systemic** |
| Bacteroides overabundance | **Systemic** |
| Impaired SCFA production | **Systemic** |
| Loss of bacterial PAMPs for DC maturation | **DC** |
| Broad-spectrum antibiotic depletion | **Systemic** |
| Impaired ICI response after antibiotics | **Systemic** |

### 10.2 Systemic Immune Dysfunction

**Age-Related Immunosenescence:**
| Mechanism | Cell Context |
|-----------|--------------|
| Thymic involution reducing naïve T cells | **Systemic** |
| Accumulation of CD28-CD57+ senescent T cells | **Teff** |
| Impaired DC function | **DC** |
| Inflammaging with chronic inflammation | **Systemic** |
| Reduced immune repertoire diversity | **Systemic** |

**Chronic Viral Infections:**
| Mechanism | Cell Context |
|-----------|--------------|
| CMV driving memory inflation | **Teff** |
| EBV skewing immune responses | **Systemic** |
| HIV-associated dysfunction | **Systemic** |
| Chronic hepatitis affecting immunity | **Systemic** |

### 10.3 Nutritional and Metabolic Factors

| Mechanism | Cell Context |
|-----------|--------------|
| Obesity: Adipokine dysregulation | **Systemic** |
| Chronic inflammation from adipose TAMs | **Systemic** |
| PD-1 upregulation in obesity | **Teff** |
| Altered lipid metabolism | **Teff** |
| Vitamin D deficiency | **Systemic** |
| Zinc/selenium deficiency | **Systemic** |

---

## 11. GENETIC AND EPIGENETIC RESISTANCE MECHANISMS

### 11.1 Driver Oncogene Effects

| Mechanism | Cell Context |
|-----------|--------------|
| EGFR mutations driving PD-L1 | **Tumor** |
| EGFR PI3K/AKT activation | **Tumor** |
| KRAS G12C/G12D immunosuppressive secretome | **Tumor** |
| KRAS + STK11 loss creating immune desert | **Tumor** |
| GM-CSF/IL-6 secretion recruiting MDSCs | **Tumor → MDSC** |

### 11.2 Tumor Suppressor Loss

| Mechanism | Cell Context |
|-----------|--------------|
| TP53: Loss of immune gene transcription | **Tumor** |
| TP53: Impaired STING pathway | **Tumor** |
| TP53: Reduced chemokine production | **Tumor** |
| PTEN: Unrestrained PI3K/AKT/mTOR | **Tumor** |
| PTEN: T cell exclusion | **Tumor → TME** |
| PTEN: Decreased IFN-responsive genes | **Tumor** |

### 11.3 Epigenetic Silencing

| Mechanism | Cell Context |
|-----------|--------------|
| DNA methylation: HLA promoters | **Tumor** |
| DNA methylation: TAP1/TAP2 | **Tumor** |
| DNA methylation: Chemokine genes | **Tumor** |
| EZH2: H3K27me3 at immune loci | **Tumor** |
| HDAC: Antigen presentation silencing | **Tumor** |
| Loss of H3K4me3 at MHC loci | **Tumor** |

### 11.4 Chromatin Remodeling Defects

| Mechanism | Cell Context |
|-----------|--------------|
| ARID1A loss affecting immune gene accessibility | **Tumor** |
| SMARCA4 (BRG1) mutations | **Tumor** |
| PBRM1 defects altering checkpoint expression | **Tumor** |

---

## CELLULAR CONTEXT LEGEND

| Color/Code | Cell Type | Description |
|------------|-----------|-------------|
| 🟡 **Tumor** | Tumor cells | Tumor intrinsic mechanisms |
| 🟢 **MDSC** | Myeloid-derived suppressor cells | M-MDSC (monocytic) and PMN-MDSC (granulocytic) |
| 🟠 **M2 / TAM** | M2 macrophages | Tumor-associated macrophages with immunosuppressive phenotype |
| 🔵 **Treg** | Regulatory T cells | CD4+FOXP3+ immunosuppressive T cells |
| 🟤 **CAF** | Cancer-associated fibroblasts | Activated fibroblasts in tumor stroma |
| 💚 **Teff** | Effector T cells | CD4+ and CD8+ effector/cytotoxic T lymphocytes |
| 💛 **TME** | Tumor microenvironment | General TME or multiple cell types |
| 🔷 **DC** | Dendritic cells | cDC1 (BATF3+), cDC2, pDC subtypes |
| 💜 **NK** | Natural killer cells | Innate lymphoid cells with cytotoxic function |
| ⚪ **Endothelial** | Endothelial cells | Tumor vasculature and blood vessels |
| 🔴 **B cells** | B lymphocytes | Antibody-producing and antigen-presenting cells |
| 🟣 **Systemic** | Systemic factors | Host-level, non-TME factors |

---

## KEY PRINCIPLES FOR BioMNI REASONING

**1. Multiple Mechanisms Coexist**
- Tumors typically employ several resistance strategies simultaneously
- Requires combination therapeutic approaches

**2. Context-Dependent Effects**
- Same mechanism may have different impacts based on tumor type, genetic background, treatment history

**3. Dynamic Evolution**
- Intrinsic resistance: Present from the start
- Adaptive resistance: Emerges during therapy

**4. Interconnected Pathways**
- Mechanisms linked through shared signaling nodes
- Offers opportunities for strategic therapeutic intervention

**5. Cellular Crosstalk**
- Cell context annotations show source → target relationships
- Example: "MDSC → Teff" means MDSC suppresses effector T cells
- Example: "Tumor → MDSC" means tumor recruits MDSCs

**6. Biomarker-Guided Strategy**
- Understanding specific resistance mechanisms enables rational combination therapy selection
- Cell-type identification allows targeted intervention design

---

## AI AGENT APPLICATIONS

This knowledge base enables BioMNI agents to:

1. **Identify resistance mechanisms** based on tumor genomics and TME composition
2. **Design rational combination therapies** targeting multiple resistance pathways
3. **Predict adaptive resistance** mechanisms that may emerge during treatment
4. **Prioritize biomarker development** for patient stratification
5. **Generate hypotheses** for novel therapeutic targets
6. **Map cellular crosstalk** networks in the tumor microenvironment
7. **Select cell-type-specific interventions** based on dominant resistance mechanisms

---

**Document Version:** 2.0 with Cellular Context  
**Created:** December 2024  
**For:** BioMNI AI Agent Reasoning Systems
