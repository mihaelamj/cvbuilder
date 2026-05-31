# CVBuilder Research Documents

Status date: 2026-05-31

This folder contains the CVBuilder evidence documents that were originally
tracked in GitHub issues. The implementation target is issue #3:

https://github.com/mihaelamj/cvbuilder/issues/3

The core boundary is:

- CVBuilder owns structured CV data and Markdown CV generation.
- Static-site generators consume the generated Markdown.
- PDF rendering is outside this research scope.

## Documents

- `cvbuilder-evidence-summary.md`
  - first-pass conclusions and current implementation constraints
- `cvbuilder-deep-review-protocol.md`
  - search protocol, inclusion/exclusion criteria, and evidence weighting
- `cvbuilder-source-matrix.md`
  - source matrix from the deeper literature pass
- `cvbuilder-proof-grade-audit.md`
  - stricter proof-grade audit plan for the next research pass

## Issue Map

- Epic: #5
- First-pass research: #7, #9, #8
- First-pass synthesis: #6
- Deep literature review: #10
- Proof-grade audit request: #11
- Implementation target: #3

## Evidence Weighting

Scientific articles carry the most weight.

Priority order:

1. Peer-reviewed journal articles and peer-reviewed conference papers.
2. Systematic reviews, meta-analyses, and well-cited academic surveys.
3. Technical papers or preprints only when peer-reviewed evidence is missing,
   clearly marked lower confidence.
4. Vendor docs, ATS-provider docs, recruiter articles, community advice, and
   anecdotes only for implementation risks or examples, never as primary
   evidence.

## Current Conclusion

The research does not support a magic best CV template. It supports a typed,
structured source of truth and a deterministic, semantic Markdown output that
makes job-relevant evidence easy to find.

For technical CVs, the strongest current rules are:

- structured `CVDocument` data is canonical
- generated Markdown is an output artifact
- use one source-order reading path
- use explicit, predictable headings
- lead experienced technical CVs with experience
- support early-career ordering separately
- nest projects/products under the relevant job
- attach technologies and technical focus areas to concrete work
- summarize public technical evidence instead of relying on raw links
- avoid scores, skill bars, personality labels, photos, demographic metadata,
  and layout-only semantics
