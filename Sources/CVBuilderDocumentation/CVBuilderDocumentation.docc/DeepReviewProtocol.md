# Deep Review Protocol

The search protocol, source list, inclusion and exclusion criteria, and confidence labels used for the deeper literature pass.

## Overview

This protocol applies to CVBuilder's technical-CV schema and Markdown renderer.
The output target is static-site-generator-agnostic Markdown generated from
structured CV data. Related issue: #10.

## Evidence Weighting

1. Peer-reviewed journal articles and conference papers.
2. Meta-analyses, systematic reviews, and well-cited academic surveys.
3. Preprints only when the area is too new for stable peer-reviewed evidence;
   marked lower confidence.
4. Vendor docs, recruiter advice, blog posts, and community folklore are
   excluded from rule-making.

## Search Strategy Used

Personnel selection and resume validity:

- `resume screening validity`
- `biodata resume screening`
- `application forms resumes validity`
- `recruiters perceptions resume information`
- `resume personality inference`

Bias and discrimination:

- `resume screening discrimination name`
- `implicit age cues resumes`
- `whitened resumes`
- `skilled immigrants resume audit`
- `gender automated resume screening`

Recruiter attention:

- `eye tracking recruiter resume`
- `computer science resume recruiter eye tracking`

Technical CVs:

- `software developer hiring GitHub Stack Overflow`
- `Visual Resume developer hiring`
- `GitHub developer profiles job advertisements`
- `software engineering hiring technical roles`
- `what makes a great software engineer`

Parsing and ATS:

- `resume information extraction`
- `resume parsing NER`
- `extracting section structure resumes`
- `RINX resume information extraction`

AI screening:

- `LLM resume screening bias`
- `algorithm-based recommendation resume screening`
- `language model retrieval resume screening`

## Sources Searched

- PubMed / PMC
- DOI landing pages
- ACM Digital Library / ACM PDFs where available
- IEEE / author-hosted IEEE paper pages
- ScienceDirect landing pages
- Springer Nature pages
- Frontiers / MDPI / PLOS / SAGE / AEA / NBER pages
- arXiv / ACL / AAAI only for newer LLM-screening work, explicitly lower
  confidence unless peer-reviewed

## Inclusion Criteria

- The source studies CV/resume screening, application forms/biodata, recruiter
  decisions, resume bias, software-developer hiring evidence, developer profile
  aggregation, or resume parsing/information extraction.
- The source has a DOI, stable publisher page, PubMed entry, ACM/IEEE/ACL
  entry, or recognized preprint record.
- Each included source must produce a concrete CVBuilder schema/rendering
  implication.

## Exclusion Criteria

- Resume-builder marketing pages.
- Vendor ATS claims without disclosed methods.
- Recruiter blog posts and anecdotal rules like "one page only", "six seconds",
  or "ATS rejects tables" unless supported by scientific parsing/attention
  evidence.
- Generic hiring advice not tied to CV/resume artifacts or technical-candidate
  evidence.

## Confidence Labels

- High: peer-reviewed empirical paper, meta-analysis, or major field experiment
  directly relevant to CV/resume screening or software hiring.
- Medium: peer-reviewed adjacent evidence where the CVBuilder implication is an
  inference.
- Low: preprint or emerging AI-screening evidence; useful as a risk signal, not
  as a stable renderer rule by itself.

## Contradiction and Uncertainty Log

Resume evidence versus application-form evidence:

- Strong literature says structured application forms are more defensible than
  resumes, but the market still asks for resumes.
- CVBuilder response: keep structured JSON canonical, then render a resume-like
  Markdown artifact.

Public developer traces:

- Technical hiring studies show GitHub and Stack Overflow can help evaluators,
  but GitHub validity studies show public traces are incomplete and easy to
  misread.
- CVBuilder response: support public technical evidence as optional structured
  summaries, not as a score or required field.

Automated screening:

- Some studies suggest automated screening can reduce specific human biases; LLM
  and retrieval studies also show algorithmic bias risks.
- CVBuilder response: do not target a specific ATS/LLM. Emit low-noise,
  explicit, auditable Markdown.

Tables:

- Tables can look compact to humans, but parser/section-structure evidence
  pushes toward simpler reading order.
- CVBuilder response: no tables for core facts unless a later parser test suite
  proves they are safe.

Personality and soft skills:

- Recruiters infer personality and soft skills from resumes, but personality
  inference from resume artifacts is weak.
- CVBuilder response: represent collaboration and communication through concrete
  work evidence, not trait adjectives.
