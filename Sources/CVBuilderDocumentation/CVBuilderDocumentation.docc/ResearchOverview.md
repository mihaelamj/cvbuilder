# Research Overview

The evidence behind CVBuilder's renderer policy, built from first principles: the founding premise, the terms, the derivation chain, and how each research document fits.

## Overview

CVBuilder's renderer makes choices, what to render, in what order, and what to
refuse, that look like opinions. They are not. Each one traces to peer-reviewed
evidence or is explicitly labelled a pragmatic convention. This article is the
entry point to that evidence. It is organized from first principles: it assumes
no background in personnel-selection research, resume parsing, or hiring law, and
builds the reasoning up from the founding premise to the enforced contract.

The core product boundary the research establishes:

- CVBuilder owns structured CV data and Markdown CV generation.
- Static-site generators consume the generated Markdown.
- PDF rendering, scoring, and ATS gaming are outside scope.

Catalog diagrams are color-coded; the legend below defines each class and is the
first diagram to read.

![Color legend for every catalog diagram](legend)

## The Founding Premise

Start from the one finding the whole literature agrees on:

> A resume or CV is not a validated selection instrument. It is weak, bias-prone,
> and partly unstructured, and treating it as a measurement of candidate quality
> is unsupported.

Everything else is derived from that premise. If a CV cannot be a valid score,
then a CV generator must not *pretend* to produce one. That single constraint
rules out skill bars, fit scores, personality labels, culture-fit labels, and
inferred seniority, before any feature is designed. What remains is a narrower,
defensible job: keep the data structured and typed, and render a clear, factual,
low-noise, deterministic artifact that makes job-relevant evidence easy to find,
for both human readers and the parsers and assistive technology that read on
their behalf.

## Prerequisites and Glossary

The research draws on five fields. A reader fluent in none of them still needs
these terms to follow the evidence:

- **Personnel selection**: the academic field studying how hiring methods
  predict job performance. Its central measure is **validity** (how well a method
  predicts performance). Resumes have low validity.
- **Field / audit experiment**: researchers send otherwise-identical fake
  resumes that differ in one signal (a name, a gap) to real job postings and
  measure the **callback rate** (the share invited to interview). The gold
  standard for causal evidence about resume signals.
- **Biodata**: biographical facts (roles, dates, education) used in screening, as
  distinct from style or self-description.
- **Eye-tracking study**: measures where recruiters actually look on a resume and
  for how long (**dwell time**).
- **Resume parsing / information extraction**: software that converts an
  unstructured resume into structured fields. **NER** (named-entity recognition)
  is the sub-task of tagging spans like an institution or a date. Parsing depends
  on **reading order**: the single linear sequence in which text should be read.
  Columns and tables scramble reading order and break extraction.
- **ATS**: applicant tracking system, the software that ingests and screens
  applications, increasingly with an LLM in the loop.
- **ESCO**: a multilingual European skills/occupations taxonomy; normalizing a
  skill to an ESCO identifier makes it machine-comparable across languages.
- **WCAG**: the Web Content Accessibility Guidelines; the success criteria cited
  here (1.3.1, 1.3.2, 2.4.6, 2.4.10) concern structure, reading order, and
  headings.
- **DOI**: a stable identifier resolving to a paper's canonical landing page;
  every high-weight source here carries one.
- **Directness / confidence**: the audit's own labels. Directness is how closely
  a source bears on CVBuilder (direct / adjacent / inferred / pragmatic);
  confidence is the evidence weight (high / medium / low). A **preprint** or
  **workshop** paper is not yet peer-reviewed and is treated as a risk signal,
  not proof.

## The Derivation Chain

The research becomes an enforced contract in four steps. Each document in this
group owns one step, and the diagram shows the flow. Colors follow the legend.

![How research becomes an enforced renderer contract](evidence-flow)

1. **Premise and method.** Define what counts as evidence and how it was
   gathered, before reading any result. Owned by <doc:DeepReviewProtocol>
   (search protocol, inclusion/exclusion criteria, confidence labels).
2. **Evidence.** Collect the peer-reviewed sources, each with method, sample,
   finding, and a concrete CVBuilder implication. Owned by <doc:SourceMatrix>
   (the deeper literature pass, 68 sources grouped by theme).
3. **Audit and decision.** Hold each candidate rule against its sources, then
   keep, revise, or downgrade it; reject folklore explicitly. Owned by
   <doc:ProofGradeAudit> (the audit standard and proof-packet schema) and
   <doc:ProofMatrix> (the source-level audit and the surviving R01-R19 rule set).
4. **Enforcement.** Map the proof-grade rules R01-R15 to code and a named test so
   drift fails the build. Owned by <doc:ConformanceMatrix>. The enrichment-pass-2
   rules R16-R19 are evidence-surviving but not yet wired to code and tests; that
   conformance work is tracked separately.

<doc:EvidenceSummary> is the synthesis across all four steps: the first-pass
findings and the implementation rules they produced, in one place.

## Reading Order

Read the group in derivation order, foundation first:

1. <doc:DeepReviewProtocol>: how evidence was selected and weighted.
2. <doc:SourceMatrix>: the sources themselves.
3. <doc:ProofGradeAudit>: the standard each rule must meet.
4. <doc:ProofMatrix>: the keep/revise/downgrade decisions and surviving rules.
5. <doc:ConformanceMatrix>: the rules wired to code and tests.
6. <doc:EvidenceSummary>: the synthesis, useful as either a primer or a recap.

## Evidence Weighting

Scientific articles carry the most weight. Priority order:

1. Peer-reviewed journal articles and peer-reviewed conference papers.
2. Systematic reviews, meta-analyses, and well-cited academic surveys.
3. Technical papers or preprints only when peer-reviewed evidence is missing,
   clearly marked lower confidence.
4. Vendor docs, ATS-provider docs, recruiter articles, community advice, and
   anecdotes only for implementation risks or examples, never as primary
   evidence.

## Measurement Discipline

Every number in this research group is a **DOCUMENTED** claim: it comes from an
external peer-reviewed source identified by DOI or stable URL, and it reports
that source's finding, not a CVBuilder measurement. Examples: "contextual skills
raised matching about 29.4%" cites Gugnani & Misra, 2020 (E52); "non-English
names received 57.4% fewer leadership callbacks" cites Adamovic & Leibbrandt,
2023 (E58). No figure in this group is invented or estimated by the project.

Two integrity rules follow:

- Sources that are not yet peer-reviewed (preprints, workshop papers) and the two
  items with an unverified DOI or author list (Skondras 2025, SkiLLMo 2025) are
  marked inline and must not be treated as high-weight proof.
- A claim of measured CVBuilder behavior (determinism, escaping, ordering) is a
  separate category: those are enforced by the named tests in
  <doc:ConformanceMatrix>, not by the hiring literature.

## Worked Example: One Rule, End to End

Trace rule **R06** ("technologies attach to concrete roles, projects, or
evidence, not only a global skills list") through all four steps:

1. **Premise and method.** The protocol admits technical-hiring and
   skill-extraction studies with disclosed methods and a concrete renderer
   implication.
2. **Evidence.** <doc:SourceMatrix> rows 18-20 and 54 supply it: Li, Ko & Zhu
   (2015) on what distinguishes strong engineers; Hauff & Gousios (2015) and
   Baltes & Diehl (2021) on extracting technology and role signals; Gugnani &
   Misra (2020), which found that skills inferred from work context improved
   resume-job matching about 29.4% over a detached skills list.
3. **Decision.** <doc:ProofMatrix> keeps R06 as direct/adjacent technical
   evidence and records the implementation action: add technologies to the role,
   project, and public-evidence models and render them near the work.
4. **Enforcement.** <doc:ConformanceMatrix> maps R06 to `WorkExperience.swift`,
   `Project.swift`, `ProjectExperience.swift`, `PublicEvidence.swift`, and
   `TechnicalFocus.swift`, and to the tests `document preserves front matter,
   links, evidence, and technical focus` and `public evidence carries context
   beyond a link`.

The result is visible in <doc:RenderingModes>: project entries render
`Technologies` and `Technical focus` beside the project, not as a detached
keyword dump.

## Issue Map

- Implementation target: [#3](https://github.com/mihaelamj/cvbuilder/issues/3).
- Epic: #5. First-pass research: #7, #9, #8. First-pass synthesis: #6.
- Deep literature review: #10. Proof-grade audit request: #11.
- Enrichment pass 2: epic #86 with children #87-#94.

## Current Conclusion

The research does not support a magic best CV template. It supports a typed,
structured source of truth and a deterministic, semantic Markdown output that
makes job-relevant evidence easy to find. The strongest current rules:

- structured `CVDocument` data is canonical; generated Markdown is the artifact
- use one source-order reading path with explicit, predictable headings
- lead experienced technical CVs with experience; treat early-career ordering as
  a separate mode, not a universal rule
- nest projects and products under the relevant job
- attach technologies and technical focus areas to concrete work
- summarize public technical evidence instead of relying on raw links
- avoid scores, skill bars, personality labels, photos, demographic metadata, and
  layout-only semantics
- mark pure renderer invariants (escaping, deterministic output) as engineering
  requirements, not scientific hiring claims
