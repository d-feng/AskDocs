TECHNICAL SPECIFICATIONS FOR ARC SYNTHESIS
Request for Proposal (RFP) to Contract Research Organizations (CROs)

SECTION 1: PROJECT OVERVIEW
Project Title
Synthesis and Quality Control of Antibody-RNA Conjugates (ARCs) for TAM-Targeted siRNA Screening
Project Scope

Deliverable: 500-1000 purified, characterized ARCs (antibody-siRNA conjugates)
Timeline: 12-16 weeks from contract execution
Application: High-throughput functional screening in tumor-associated macrophages
End Use: Research use only (not GMP, but high quality required)

Background & Purpose
We are conducting a systematic siRNA screen to identify therapeutic targets in tumor-associated macrophages (TAMs). We require ARCs comprising anti-CD206 antibody conjugated to custom siRNA sequences via cleavable linker chemistry. Each ARC must demonstrate:

Specific binding to CD206+ cells
Efficient internalization
Functional gene knockdown (>70%)
Reproducible quality (DAR, purity, aggregation)


SECTION 2: MATERIALS TO BE PROVIDED BY CLIENT
What We Will Provide:
2.1 Antibody

Identity: Anti-CD206 antibody, Clone [Specify: e.g., 15-2 or custom]
Species/Isotype: Rat IgG2a or Mouse IgG1 (specify after selection)
Format: Full IgG (150 kDa)
Purity: >95% by SEC-HPLC
Concentration: 5-10 mg/mL in PBS pH 7.4
Quantity to Provide: 200-300 mg total (for 500-1000 ARCs)
Storage: -80°C in aliquots
Additional Info: Certificate of analysis (CoA) will be provided

2.2 siRNA Sequences

Number of Sequences: 500-1000 unique siRNA duplexes
Format: Excel spreadsheet with:

Gene name
Sense strand sequence (5' to 3', 21 nt)
Antisense strand sequence (5' to 3', 21 nt)
Target organism (human)
Any off-target concerns flagged


Chemical Modifications Required (see Section 3.1)
Controls: Positive (PLK1, CSF1R), negative (scrambled, non-targeting)

2.3 Reference Standards

Unconjugated anti-CD206 antibody (for binding comparisons)
Fluorescently labeled anti-CD206 (Alexa488) for uptake validation
siRNA positive controls (pre-validated sequences)


SECTION 3: DETAILED TECHNICAL REQUIREMENTS
3.1 siRNA Specifications
Chemical Modifications (CRITICAL):
Sense Strand (Passenger):

5' Modification: Thiol-C6-SS (disulfide spacer)

Structure: 5'-HS-(CH₂)₆-SS-(CH₂)₆-[RNA sequence]-3'
Purpose: Conjugation to antibody via maleimide chemistry
Must be reducible with TCEP


2'-O-Methylation: Positions 1, 3, 5, 7, 9, 11, 13, 15, 17, 19 (all purines and pyrimidines at odd positions)

Purpose: Nuclease stability


3' Phosphorothioate: Last two nucleotides (positions 20-21)

Purpose: Exonuclease resistance


3' Overhang: dTdT (2'-deoxythymidine) standard overhang

Antisense Strand (Guide):

5' Phosphate: Required for RISC loading
2'-O-Methylation: Positions 2, 4, 6, 8, 10, 12, 14, 16, 18 (alternating pattern)
3' Phosphorothioate: Last two nucleotides
3' Overhang: dTdT

Additional Requirements:

Duplex annealing: Pre-annealed in buffer (not lyophilized separately)
Purification: HPLC-grade (>90% purity by HPLC)
Endotoxin: <0.5 EU/μg
RNase-free: All handling in RNase-free conditions

Questions for CRO:

Can you synthesize siRNA with 5'-thiol-C6-SS modification? If not, what alternatives do you offer?
What is your standard pattern for 2'-O-methyl modifications? Can you accommodate our specific pattern?
Do you provide pre-annealed duplexes or separate strands? What annealing buffer do you use?
What is your typical purity by HPLC? Can you guarantee >90%?
What is your endotoxin testing method and typical levels achieved?
Can you provide analytical data for each siRNA (MS, HPLC trace)?


3.2 Conjugation Chemistry
Preferred Method: Maleimide-Thiol Conjugation
Step 1: Antibody Reduction

Reduce interchain disulfides to generate free cysteines
Reducing Agent: TCEP (tris(2-carboxyethyl)phosphine) preferred

Concentration: 1-3 mM (optimize for DAR 2-4)
Temperature: 37°C
Time: 2 hours
Buffer: PBS pH 7.4, degassed


Removal: Immediate desalting (Zeba column, NAP-10, or dialysis)
Target: 2-4 free cysteines per antibody (measure by Ellman's assay)

Step 2: siRNA-Maleimide Activation

siRNA with 5'-thiol reduced if oxidized (TCEP treatment)
Conjugation to heterobifunctional crosslinker
Crosslinker: SM(PEG)₁₂ (Succinimidyl-[(N-maleimidopropionamido)-dodecaethyleneglycol] ester)

MW: 774.8 Da
PEG₁₂ spacer provides flexibility
Alternative: Sulfo-SMCC (water-soluble)


Reaction: 2-4 hours at room temperature
Purification: Remove excess crosslinker (SEC, precipitation, or HPLC)

Step 3: Antibody-siRNA Conjugation

Mix reduced antibody + siRNA-maleimide
Molar Ratio: 1:3 to 1:5 (Ab:siRNA) - optimize for DAR 2-4
Buffer: PBS pH 7.0-7.2, degassed (prevent re-oxidation)
Temperature: 4°C or room temperature
Time: 4 hours to overnight
Quenching: N-acetyl cysteine or β-mercaptoethanol (cap unreacted maleimides)

Step 4: Purification

Remove unconjugated siRNA and excess reagents
Methods (in order of preference):

Size exclusion chromatography (SEC) - Best purity
Centrifugal filtration (Amicon Ultra 50K MWCO) - Scalable
Protein A affinity (for IgG only) - Fast but harsh (low pH)


Buffer Exchange: Into PBS pH 7.4 + 10% glycerol (storage buffer)
Concentration: 1-3 mg/mL (optimal for storage)

Questions for CRO:

What conjugation chemistry do you typically use for antibody-oligonucleotide conjugates?
Do you have experience with maleimide-thiol chemistry? If so, what crosslinkers do you prefer?
What is your antibody reduction protocol? Do you measure free thiols?
What molar ratios (Ab:siRNA) do you test to achieve target DAR?
What purification methods do you use? Can you provide SEC-HPLC chromatograms?
How do you prevent antibody aggregation during conjugation and purification?
What is your typical yield (mg ARC output per mg antibody input)?
Can you handle 500-1000 individual sequences or do you require batching?


3.3 Quality Control Requirements
QC Panel (Required for ALL ARCs):
3.3.1 Drug-to-Antibody Ratio (DAR)

Method: RiboGreen fluorescence assay + protein quantification

Protein: A280 absorbance (with extinction coefficient) or BCA assay
siRNA: RiboGreen (Quant-iT RNA assay kit or equivalent)
Calculation: DAR = (moles siRNA) / (moles antibody)


Acceptance Criteria: DAR 2.0-4.0
Reporting: Mean DAR ± SD, individual values in CoA

3.3.2 Purity & Aggregation

Method: SEC-HPLC (size exclusion chromatography)

Column: TSKgel G3000SWxl or Superdex 200 Increase
Mobile phase: PBS pH 7.4
Detection: A280 nm (protein) and A260 nm (RNA)


Acceptance Criteria:

Monomer: >90%
Aggregates: <5%
Fragments: <5%


Reporting: Chromatogram (overlay A280/A260), % monomer calculated

3.3.3 Concentration

Method: UV absorbance (A280) with correction for RNA contribution

Formula: [Protein] = (A280 - A260 × 0.5) / ε₂₈₀
Alternative: BCA assay (not affected by RNA)


Acceptance Criteria: 1-5 mg/mL
Reporting: mg/mL, volume, total mass

3.3.4 Visual Inspection

Criteria: Clear, colorless to pale yellow solution, no particulates
Reporting: Pass/Fail

3.3.5 pH

Method: pH meter
Acceptance Criteria: pH 7.0-7.6
Reporting: pH value

Questions for CRO:

Do you have validated assays for DAR measurement? What is your method?
Can you perform SEC-HPLC with dual wavelength detection (A280 and A260)?
What is your typical %monomer for antibody conjugates?
How do you calculate DAR? Can you provide sample calculations and validation data?
What quality control tests are included in your standard package vs. additional cost?


QC Panel (Required for SUBSET - 10% Random Sampling):
3.3.6 SDS-PAGE

Method: Non-reducing and reducing conditions

Non-reducing: Shows intact ARC (heavy chain + siRNA ~70 kDa)
Reducing: Shows separated chains (HC ~50 kDa, LC ~25 kDa, free siRNA ~14 kDa)


Acceptance Criteria:

Non-reducing: >60% heavy chains show upward shift (conjugation)
Reducing: Expected band pattern


Reporting: Gel images (annotated), % conjugation estimated by densitometry

3.3.7 Mass Spectrometry

Method: Intact mass (ESI-MS or MALDI-TOF)

Desalted sample in 50% acetonitrile, 0.1% formic acid


Purpose: Confirm conjugation, determine DAR distribution
Acceptance Criteria: Molecular weight consistent with antibody + 2-4 siRNAs
Reporting: Mass spectrum, deconvoluted mass, DAR distribution

3.3.8 Binding Activity

Method: ELISA with recombinant CD206-Fc

Coat plate with CD206-Fc (1 μg/mL)
Titrate ARC (0.001-10 μg/mL, 8-point curve)
Detect with anti-species-HRP secondary
Calculate EC50


Acceptance Criteria: EC50 within 3-fold of unconjugated antibody
Reporting: Binding curve, EC50 value, comparison to parent antibody

Questions for CRO:

Can you provide SDS-PAGE analysis? What percentage will you run (10%, 20%, all)?
Do you have mass spectrometry capabilities? What platform (ESI, MALDI)?
Can you perform binding assays? Do you require recombinant antigen or will you use cell-based assays?
What is the cost difference between basic QC (DAR, SEC, concentration) vs. comprehensive QC (add MS, binding)?


QC Panel (Required for CONTROLS - Critical ARCs):
3.3.9 Functional Validation (Cell-Based)

Method: Transfection of CD206+ M2 macrophages

Add ARC (50-200 nM) to cells
Incubate 72 hours
Measure knockdown by qRT-PCR


Acceptance Criteria: >70% knockdown of target gene
Reporting: % knockdown, positive control (PLK1) must work
Note: This may need to be done by client unless CRO has appropriate cells

3.3.10 Endotoxin Testing

Method: LAL (Limulus Amebocyte Lysate) assay
Acceptance Criteria: <0.5 EU/mg protein
Reporting: EU/mg value

3.3.11 Sterility

Method: USP sterility test or 0.22 μm filtration
Acceptance Criteria: Sterile (no growth in 14-day culture)
Reporting: Pass/Fail

Questions for CRO:

Can you perform functional knockdown assays in cells? If so, what cell types?
Do you routinely test for endotoxin? What are your typical levels?
Are ARCs sterile-filtered as standard? What filtration method?
Can you provide stability testing (freeze-thaw, long-term storage)?


3.4 Formulation & Delivery
Final Formulation:

Buffer: PBS pH 7.4 + 10% glycerol (cryoprotectant)

Alternative: PBS + 5% trehalose


Concentration: 2 μM (for screening use) OR 1-3 mg/mL (stock)
Volume per ARC:

Option 1: 50-100 μL per tube (individual tubes)
Option 2: 500-1000 μL bulk (we will aliquot)


Container:

Individual: 1.5 mL screw-cap tubes (sterile, RNase-free)
Bulk: 5 mL cryovials
Plate format: 96-well PCR plates (sealed)



Labeling:

Required Information on Each Container:

ARC ID (unique identifier, e.g., ARC-001)
Gene name and siRNA sequence ID
Concentration (mg/mL or μM)
DAR value
Lot/Batch number
Synthesis date
Expiration date (if applicable)
Storage conditions (-80°C)



Shipping:

Temperature: Dry ice (maintain -80°C during transit)
Packaging: Insulated shipper, temperature logger
Documentation:

Packing list (all ARCs with IDs)
Certificates of Analysis (CoA) for each ARC
Summary QC report (aggregate statistics)



Questions for CRO:

What storage buffer do you recommend for ARCs?
Can you formulate ARCs in 96-well plates for direct screening use?
What is your standard container format? Can you accommodate custom requests?
How do you ensure temperature control during shipping?
Do you provide electronic CoAs or only paper? Can data be provided in Excel/CSV?
What is your labeling system? Can you use our identifiers?


SECTION 4: ANALYTICAL METHODS & DOCUMENTATION
4.1 Standard Operating Procedures (SOPs)
Questions for CRO:

Can you provide copies of relevant SOPs? (redacted if proprietary)

Antibody-oligonucleotide conjugation SOP
DAR measurement SOP
SEC-HPLC SOP
Purification SOP


Are your SOPs validated and version-controlled?
Who reviews and approves SOPs?


4.2 Certificate of Analysis (CoA)
Required Information in CoA:

Unique ARC ID
Gene name, siRNA sequence
Antibody information (lot, source)
Synthesis date, analyst initials
Analytical Results:

DAR (value, method)
SEC-HPLC (% monomer, chromatogram)
Concentration (mg/mL, method)
pH
Visual inspection (pass/fail)
SDS-PAGE (if performed, gel image)
Mass spec (if performed, spectrum)
Binding activity (if performed, EC50)
Endotoxin (if performed, EU/mg)


Acceptance Criteria: Pass/Fail for each test
Overall Conclusion: Acceptable for use / Not acceptable
Storage: Conditions, expiration
Signatures: Analyst, QC reviewer, approver

Questions for CRO:

Can you provide a template CoA for review?
In what format do you provide CoAs (PDF, Excel, both)?
Can CoAs include raw data (not just pass/fail)?
What is your turnaround time for CoA generation after synthesis?


4.3 Batch Documentation
Master Batch Record (MBR):

Documentation of all synthesis steps
Dates, times, personnel
Deviations from protocol (if any)
In-process testing results
Final disposition

Questions for CRO:

Do you maintain batch records for each ARC or only for batches of multiple ARCs?
Can you provide batch records upon request (for regulatory or publication purposes)?
How long do you retain records and samples?


SECTION 5: PROJECT MANAGEMENT
5.1 Timeline & Deliverables
Proposed Timeline:

Week 0: Contract execution, materials transfer
Week 1-2: Method optimization (pilot batch of 5-10 ARCs)
Week 3-14: Production synthesis (500-1000 ARCs)

Batches of 50-100 ARCs per week?


Week 15-16: Final QC, documentation, shipping

Questions for CRO:

What is your estimated timeline for this project?
Can you process 500-1000 unique sequences in 12-16 weeks?
What is your throughput (ARCs per week)?
Will you synthesize all siRNAs first, then conjugate? Or parallel?
What is your batch size (how many ARCs synthesized simultaneously)?
If timelines slip, what is your contingency plan?


5.2 Communication & Reporting
Requirements:

Project Kick-off Meeting: Discuss protocols, timelines, expectations
Weekly Updates: Email or call, progress report
Monthly Reports: Detailed summary (ARCs completed, QC results, issues)
Issue Escalation: Immediate notification if problems arise (failed QC, delays)
Final Report: Comprehensive summary at project end

Questions for CRO:

Who will be the primary point of contact for this project?
What is their experience with antibody-oligonucleotide conjugates?
How frequently will you provide updates?
What is your process for handling failed QC batches? Will you re-synthesize?
Do you provide a final project report summarizing all work?


5.3 Quality Assurance
Questions for CRO:

Is your facility GLP-compliant? (Not required but preferred)
Do you have ISO certification? (e.g., ISO 9001)
What is your quality management system?
How do you handle complaints or quality issues?
Can we audit your facility if needed?
What is your policy on sample retention? Can you keep reserve samples?


SECTION 6: INTELLECTUAL PROPERTY & CONFIDENTIALITY
6.1 Confidentiality
Questions for CRO:

Will you sign a Confidential Disclosure Agreement (CDA)?
How do you protect client proprietary information?
Will our siRNA sequences and antibody information remain confidential?
Do you work with our competitors? How do you manage conflicts?


6.2 Intellectual Property
Questions for CRO:

Who owns IP generated during this project?

We expect: Client owns all IP related to sequences, targets, ARCs
CRO may own: Generic methods/processes (if novel)


If you develop novel conjugation methods during our project, what are the IP terms?
Can we publish results without restriction (with appropriate confidentiality protections)?
Can we patent ARCs and their uses without IP conflicts?


6.3 Material Transfer
Questions for CRO:

Do you require a Material Transfer Agreement (MTA) for the antibody we provide?
Who owns leftover antibody and siRNA after project completion?
Can we request return of unused materials?


SECTION 7: PRICING & TERMS
7.1 Cost Structure
Questions for CRO:

Per-ARC Pricing:

What is your cost per ARC (synthesis + basic QC)?
Is there a volume discount (e.g., >100, >500 ARCs)?
Estimated range: $300-800 per ARC? (Please provide quote)


siRNA Synthesis:

If you synthesize siRNA in-house, what is the cost per sequence?
Do you require us to provide siRNA, or can you synthesize?
If we provide siRNA, does that reduce cost?


Additional QC Costs:

What is included in base price?
Cost for SDS-PAGE per sample?
Cost for mass spec per sample?
Cost for binding assay per sample?
Cost for functional validation per sample?


Setup & Development:

Are there upfront costs (method development, optimization)?
Pilot batch cost (5-10 ARCs for method validation)?


Project Management:

Are project management fees separate or included?
What about report generation, CoA preparation?



Sample Pricing Request:
Please provide a detailed quote for:

Scenario A: 500 ARCs (basic QC: DAR, SEC, concentration)
Scenario B: 500 ARCs (comprehensive QC: add SDS-PAGE, MS, binding for 10%)
Scenario C: 1000 ARCs (basic QC)

For each scenario, please break down:

Per-ARC cost
Total cost
Timeline


7.2 Payment Terms
Questions for CRO:

What are your payment terms?

Typical: 50% upfront, 50% upon delivery?
Or milestone-based (e.g., 30% at start, 40% at midpoint, 30% at completion)?


Do you require a purchase order (PO) or contract?
What currencies do you accept?
Are there cancellation fees if project is terminated early?


7.3 Warranties & Liabilities
Questions for CRO:

What is your policy if ARCs fail QC?

Will you re-synthesize at no charge?
What is the maximum number of re-synthesis attempts?


Do you guarantee a minimum success rate (e.g., 80% of ARCs pass QC)?
What happens if ARCs don't perform functionally in our assays?

Do you offer troubleshooting support?
Are there refunds or credits?


What is your liability if there are delays?
Do you have professional liability insurance?


SECTION 8: TECHNICAL EXPERTISE & EXPERIENCE
8.1 CRO Qualifications
Questions for CRO:

Antibody-Oligonucleotide Conjugate Experience:

How many ADCs or AOCs have you synthesized?
What types of oligonucleotides (siRNA, ASO, miRNA, aptamers)?
What antibody formats (IgG, F(ab')₂, scFv, nanobodies)?
What conjugation chemistries (maleimide-thiol, click, enzymatic)?


High-Throughput Capabilities:

Have you synthesized libraries (>100 conjugates) before?
What is the largest library you've produced?
How do you ensure consistency across large batches?


siRNA-Specific Experience:

Have you worked with modified siRNA (2'-OMe, PS, thiol)?
Experience with siRNA stability, handling, storage?
Any issues with siRNA conjugation you've encountered and overcome?


Antibody Experience:

Do you work with multiple antibody species (rat, mouse, human)?
Experience with partial reduction (vs. complete denaturation)?
How do you preserve antibody activity during conjugation?


Relevant Publications or Case Studies:

Can you provide references, publications, or case studies?
Client testimonials (with permission)?




8.2 Facility & Equipment
Questions for CRO:

Location: Where are your facilities located?
Equipment Available:

FPLC/HPLC systems (models?)
Mass spectrometers (type?)
Plate readers, flow cytometers (for functional testing?)


Capacity: Can you handle this project volume without delays?
Backup Systems: What happens if equipment breaks down?


8.3 Staff Expertise
Questions for CRO:

Who will be working on our project (roles, experience)?
What are the qualifications of the synthesis chemist(s)?
What are the qualifications of QC analysts?
Will the same team work on the entire project (consistency)?


SECTION 9: RISK MITIGATION & TROUBLESHOOTING
9.1 Anticipated Challenges
Questions for CRO:

What are common failure modes for antibody-siRNA conjugates?

Aggregation? How do you prevent/address?
Low DAR? How do you optimize?
Loss of binding activity? How do you mitigate?
Poor solubility? Formulation strategies?


Have you encountered issues with:

Specific antibody isotypes (rat IgG2a)?
Thiol-modified siRNA (oxidation, instability)?
CD206 antibody specifically?


If an ARC fails QC:

Do you investigate root cause?
Will you re-optimize for that specific sequence?
How many attempts before declaring a sequence "un-conjugatable"?




9.2 Contingency Planning
Questions for CRO:

If maleimide-thiol chemistry doesn't work well:

What alternative conjugation methods can you offer?
Click chemistry (azide-alkyne)?
Sortase or transglutaminase (enzymatic)?
Direct NHS-ester (less site-specific)?


If target DAR cannot be achieved:

Is DAR 1-2 acceptable (lower payload)?
Is DAR 5-6 acceptable (higher aggregation risk)?
How would this affect pricing/timeline?


If throughput is slower than expected:

Can you add staff or equipment?
Can you work overtime/weekends?
What is the cost for expedited service?


If we need to change specifications mid-project:

How flexible can you be?
What is the cost/timeline impact of changes?
Examples: Change antibody clone, modify siRNA chemistry, adjust DAR target




SECTION 10: REGULATORY & COMPLIANCE
10.1 Regulatory Support
Questions for CRO:

Although this is research-grade (not GMP), can you provide:

Documentation suitable for IND submissions (future)?
Batch records, CoAs in IND-compatible format?
Stability data (accelerated and real-time)?


If we decide to move to GMP in future (Year 2-3):

Can you scale up to GMP manufacturing?
Do you have GMP facilities or partnerships?
What would be the cost/timeline difference?




10.2 Safety & Compliance
Questions for CRO:

Are you compliant with:

OSHA (chemical safety)?
EPA (waste disposal)?
Local regulations for biohazard materials?


How do you handle:

Disposal of failed batches, waste siRNA, solvents?
Do you have permits for all chemicals used?




SECTION 11: REFERENCE CHECKS
11.1 Previous Clients
Questions for CRO:

Can you provide references from previous clients who have done similar projects?

Specifically: Antibody-oligonucleotide conjugates
Specifically: High-throughput libraries
Contact information (with permission)


Examples of similar projects:

Project scope, outcomes, client satisfaction
Any published papers using your ARCs/AOCs?




SECTION 12: ADDITIONAL SERVICES
12.1 Optional Add-Ons
Questions for CRO:

Can you provide additional services?

Fluorescent labeling (for uptake studies)?
Antibody engineering (if we need to optimize CD206 antibody)?
Formulation development (alternative buffers, lyophilization)?
Stability studies (freeze-thaw, temperature, time)?


Can you assist with in vivo studies?

Do you have in vivo capabilities or partnerships?
PK/PD studies in mice?
Biodistribution studies?


Can you help with assay development?

Optimization of cell-based knockdown assays?
Flow cytometry assay for binding/uptake?
ELISA development for CD206 binding?




SECTION 13: PROPOSAL SUBMISSION REQUIREMENTS
Please Provide in Your Proposal:
13.1 Technical Proposal:

 Detailed conjugation protocol (overview)
 QC methods and acceptance criteria
 Timeline with milestones (Gantt chart)
 Risk assessment and mitigation strategies
 Staff CVs or qualifications summary
 Facility description and equipment list

13.2 Pricing Proposal:

 Itemized quote (per-ARC cost, total project)
 Volume discounts
 Optional services pricing
 Payment terms

13.3 Supporting Documents:

 Company overview, certifications (ISO, etc.)
 Sample CoA (redacted previous project)
 Sample QC data (SEC-HPLC chromatogram, MS spectrum)
 Client references (3 minimum)
 Standard contracts or MTAs (for review)
 CDA template