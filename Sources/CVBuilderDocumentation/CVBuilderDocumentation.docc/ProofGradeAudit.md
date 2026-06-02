# Proof-Grade Evidence Audit

The audit plan: evidence standard, the proof packet schema, the claims to prove or reject, and acceptance criteria.

## Overview

This article defines the proof-grade audit. The completed proof matrix and final
rule decisions live in <doc:ProofMatrix>. Related issue: #11.

## Goal

Run a proof-grade scientific-literature audit for CVBuilder's technical-CV
schema and Markdown renderer rules.

The audit must verify the strongest implementation rules against source-level
evidence and produce a proof packet that can withstand skeptical review.

## Evidence Standard

Scientific articles carry the most weight. Every recommendation must be
traceable to primary evidence or explicitly marked as unsupported/pragmatic.

Allowed high-weight evidence:

- peer-reviewed journal articles
- peer-reviewed conference papers
- meta-analyses and systematic reviews
- field experiments and controlled experiments
- empirical software-engineering studies with disclosed methods
- resume parsing / information extraction papers with disclosed datasets,
  methods, or evaluation metrics

Allowed lower-weight evidence:

- preprints for emerging AI/LLM screening risks, clearly marked as not final
  proof
- technical reports only when the methods are inspectable and no peer-reviewed
  equivalent exists

Excluded from proof:

- recruiter blog posts
- ATS vendor claims
- resume-builder marketing
- anecdotal rules such as "six seconds", "one page", "ATS rejects tables", or
  "keywords beat context" unless a scientific source proves the specific claim

## Required Proof Packet

For every CVBuilder rule that remains after the audit, record:

- rule ID
- exact rule text
- source citation
- DOI or stable URL
- source type and venue
- method
- sample/population
- relevant measured result or finding
- directness: direct / adjacent / inferred / pragmatic
- limitations
- confidence: high / medium / low
- whether the rule affects schema, Markdown rendering, fixtures, or tests
- exact #3 implementation change, if any

Do not use long copyrighted excerpts. Short source snippets are allowed only
when needed and must remain minimal; otherwise paraphrase findings and cite the
source.

## Claims to Prove or Reject

Audit these specific CVBuilder rules:

1. Structured JSON/CVDocument should be canonical; Markdown should be generated.
2. Technical CV output should use one source-order reading path.
3. Experienced technical candidates should lead with experience.
4. Early-career technical candidates may need education/projects earlier.
5. Projects/products should nest under the job where the work happened.
6. Technologies should be attached to concrete roles/projects, not only global
   skills.
7. Public technical evidence should include a summary, not only a link.
8. Public developer traces should not be scored.
9. CVBuilder should not render skill bars, fit scores, personality labels, or
   culture-fit labels.
10. CVBuilder should avoid photos/icons/demographic metadata by default.
11. CVBuilder should avoid tables/columns/images for core facts unless parser
    tests prove safety.
12. Markdown escaping and deterministic rendering should be required.
13. Global skills should stay compact and grouped near the end.
14. Technical area/focus tags should attach to actual work, not become keyword
    stuffing.
15. CVBuilder should not optimize for a specific ATS/LLM; it should emit
    factual, low-noise, auditable Markdown.

## Suggested Source Families to Re-check

- Personnel-selection validity: Schmidt & Hunter; Sackett et al.; structured
  forms/biodata literature.
- Resume screening behavior: Cole et al.; recruiter inference papers;
  eye-tracking resume studies.
- Discrimination and cue effects: Bertrand & Mullainathan; Kang et al.;
  Derous/Decoster; Oreopoulos; technical-hiring discrimination studies.
- Technical hiring: Kuttal et al.; Marlow/Dabbish/Herbsleb; Li/Ko/Zhu;
  Hauff/Gousios; Baltes/Diehl; GitHub-mining validity papers.
- Parser structure: RINX; resume education NER; section structure extraction;
  document layout extraction.
- AI screening: peer-reviewed LLM/resume-screening bias work only, plus clearly
  marked preprints if necessary.

## Deliverables

- A proof matrix posted as an issue comment or checked-in research document.
- A contradiction log: rules that are weak, unsupported, contradicted, or only
  pragmatic.
- A final decision table: keep / revise / remove each audited rule.
- A #3 update comment listing only the rules that survive proof-grade audit.
- If a previous #3 rule is weak, explicitly mark it as pragmatic or
  remove/revise it.

## Acceptance Criteria

- Every audited rule has at least one cited evidence entry or is explicitly
  downgraded to pragmatic.
- At least 25 high-weight scientific sources are reviewed, or the issue
  documents why the available literature is thinner.
- At least 10 sources are technical/software-engineering-specific or
  parser-specific.
- Every source row includes method, sample/population, limitation, and CVBuilder
  implication.
- Unsupported resume folklore is rejected explicitly.
- The final #3 update contains no rule presented as evidence-backed unless the
  proof matrix supports it.
- The issue is closed only after the proof matrix and final decision table are
  posted.
