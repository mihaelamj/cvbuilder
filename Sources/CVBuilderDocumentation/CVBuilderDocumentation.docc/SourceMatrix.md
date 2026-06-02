# Source Matrix

The deeper literature review, grouped by theme, with each source's method, strength, and concrete CVBuilder implication.

## Overview

This matrix summarizes the deeper literature review. It is not a proof-grade
audit. The stricter proof-grade audit is tracked in <doc:ProofGradeAudit>, and
the final keep/revise/downgrade decisions live in <doc:ProofMatrix>. Related
issue: #10.

## General CV / Resume Selection Evidence

| # | Source | Area | Evidence / method | Strength | CVBuilder implication |
|---|---|---|---|---|---|
| 1 | Schmidt & Hunter, 1998, Psychological Bulletin, "The Validity and Utility of Selection Methods in Personnel Psychology". DOI: https://doi.org/10.1037/0033-2909.124.2.262 | Personnel selection validity | Meta-analysis across selection methods. | High, broad personnel-selection evidence. | A CV should not pretend to be a validated selection instrument. CVBuilder should produce structured evidence, not personality scores or pseudo-rankings. |
| 2 | Sackett, Zhang, Berry, & Lievens, 2022, Journal of Applied Psychology, "Revisiting meta-analytic estimates of validity in personnel selection". DOI: https://doi.org/10.1037/apl0000994 | Personnel selection validity | Meta-analytic correction/validity reassessment. | High for selection-method caution. | Keep CV claims factual and verifiable. Do not encode speculative scoring in the renderer. |
| 3 | Risavy, Robie, Fisher, & Rasheed, 2022, Frontiers in Psychology, "Resumes vs. application forms". DOI: https://doi.org/10.3389/fpsyg.2022.884205 | Resume vs structured forms | Peer-reviewed perspective grounded in validity and DEI literature. | High for structured-data direction. | `CVDocument` should be canonical; Markdown is generated presentation. Structured fields are more defensible than ad hoc Markdown authoring. |
| 4 | Brown & Campion, 1994, Journal of Applied Psychology, "Biodata phenomenology". DOI: https://doi.org/10.1037/0021-9010.79.6.897 | Biodata and recruiter interpretation | Recruiter perception/use of biographical information in screening. | High for how resume facts are interpreted. | CVBuilder should separate biographical evidence fields from renderer style. Use explicit fields for roles, education, technologies, and public work. |
| 5 | Cole, Rubin, Feild, & Giles, 2007, Applied Psychology, "Recruiters' perceptions and use of applicant resume information". DOI: https://doi.org/10.1111/j.1464-0597.2007.00288.x | Resume screening behavior | Empirical study of recruiter use of resume information. | High for resume-screening behavior. | Make job-relevant facts easy to locate: organization, title, dates, education, projects, and technologies. |
| 6 | Cole, Feild, Giles, & Harris, 2009, Journal of Business and Psychology, "Do Paper People have a Personality?" DOI: https://doi.org/10.1007/s10869-008-9086-9 | Personality inference from resumes | Empirical study of recruiter personality inferences from resume screening. | High for rejecting trait-heavy CV design. | Avoid trait claims as primary content. Prefer evidence of work performed and outcomes. |
| 7 | Apers & Derous, 2017, Computers in Human Behavior, "Are they accurate? Recruiters' personality judgments in paper versus video resumes". DOI: https://doi.org/10.1016/j.chb.2017.02.063 | Resume media and personality inference | Empirical study with recruiters comparing paper/audio/video resume formats. | High for avoiding richer-media/personality cues. | Do not add photos, visual persona, video-like cues, or personality-oriented design elements. |
| 8 | Wright, Domagalski, & Collins, 2011, Business Communication Quarterly, "Improving Employee Selection With a Revised Resume Format". DOI: https://doi.org/10.1177/1080569911413809 | Resume format and selection quality | Study of adding structured information to resume format. | Medium; practical format study, not technical-CV-specific. | Prefer consistent structured sections and fields over freeform layout novelty. |
| 9 | Pina et al., 2023, Machine Learning and Knowledge Extraction, "Using Machine Learning with Eye-Tracking Data to Predict if a Recruiter Will Approve a Resume". DOI: https://doi.org/10.3390/make5030038 | Recruiter attention / CS resumes | Eye-tracking study on computer-science resumes; eye data predicted approval above chance. | High for technical-CV readability. | Experience and education must be prominent, concise, and easy to absorb. Avoid dense prose and hidden structure. |
| 10 | Bertrand & Mullainathan, 2004, American Economic Review, "Are Emily and Greg More Employable than Lakisha and Jamal?" DOI: https://doi.org/10.1257/0002828042002561 | Resume audit / racial discrimination | Field experiment varying names on resumes. | High, landmark field evidence. | Do not add unnecessary demographic cues. Render job-relevant details only. |
| 11 | Derous & Decoster, 2017, Frontiers in Psychology, "Implicit Age Cues in Resumes". DOI: https://doi.org/10.3389/fpsyg.2017.01321 | Age cues and hiring discrimination | Experimental resume-screening study. | High for demographic-cue caution. | Do not render birthdate, age, graduation age cues, or extra chronology beyond role/education dates needed for job relevance. |
| 12 | Kang, DeCelles, Tilcsik, & Jun, 2016, Administrative Science Quarterly, "Whitened Resumes". DOI: https://doi.org/10.1177/0001839216639577 | Race, self-presentation, and labor market | Field/experimental work on racial concealment in resumes. | High for risk of identity signaling effects. | CVBuilder should avoid adding identity-signaling sections by default. Public evidence sections must be job-relevant, not affinity/decorative identity sections. |
| 13 | Oreopoulos, 2011, American Economic Journal: Economic Policy, "Why Do Skilled Immigrants Struggle in the Labor Market?" DOI: https://doi.org/10.1257/pol.3.4.148 | Resume audit / immigrant discrimination | Field experiment with randomized resumes. | High for demographic and credential-cue caution. | Prefer normalized, explicit credential fields; avoid renderer embellishments that amplify non-job-relevant origin cues. |
| 14 | Pisanelli, 2022, Economics Letters, "Your resume is your gatekeeper". DOI: https://doi.org/10.1016/j.econlet.2022.110892 | Automated screening and gender gaps | Field study on automated resume screening. | Medium-high; relevant to automation, but not renderer-specific. | Make generated Markdown parseable and structured. Avoid hidden semantics in layout. |
| 15 | Buijsrogge, Derous, & Duyck, 2016, Human Performance, "Often biased but rarely in doubt". DOI: https://doi.org/10.1080/08959285.2016.1165225 | Stigma and interviewer confidence | Interview-stage stigma / initial-reaction evidence. | Medium; adjacent evidence, not resume-specific. | Avoid CV-renderer features that invite early subjective impressions unrelated to job evidence. |

## Technical CVs, Parsing, and AI-Screening Evidence

| # | Source | Area | Evidence / method | Strength | CVBuilder implication |
|---|---|---|---|---|---|
| 16 | Kuttal et al., 2021, Information and Software Technology, "Visual Resume: Exploring developers' online contributions for hiring". DOI: https://doi.org/10.1016/j.infsof.2021.106633 | Developer hiring / online contributions | Design/evaluation study around aggregating GitHub and Stack Overflow evidence. | High for technical-CV public-evidence design. | Add structured public-evidence sections, but summarize relevance in CV text; do not force reviewers to inspect raw profiles. |
| 17 | Marlow, Dabbish, & Herbsleb, 2013, CSCW, "Impression Formation in Online Peer Production". DOI: https://doi.org/10.1145/2441776.2441792 | GitHub activity traces | Qualitative study of impression formation from GitHub profiles/activity. | High for public technical trace interpretation. | Support project/profile links with context: role, contribution type, project relevance, collaboration evidence. |
| 18 | Li, Ko, & Zhu, 2015, ICSE, "What Makes a Great Software Engineer?" DOI: https://doi.org/10.1109/ICSE.2015.335 | Software engineering expertise | Empirical study of attributes of great software engineers. | High for technical-content schema direction. | Represent engineering judgment, learning, communication, quality, maintainability, and impact; do not reduce technical CVs to language/tool inventory. |
| 19 | Hauff & Gousios, 2015, MSR, "Matching GitHub Developer Profiles to Job Advertisements". DOI: https://doi.org/10.1109/MSR.2015.41 | GitHub profile/job matching | Pipeline matching job ads to GitHub profile concepts. | Medium-high for structured technology signals. | Keep technologies structured and attached to roles/projects; avoid detached keyword stuffing. |
| 20 | Baltes & Diehl, 2021, Information and Software Technology, "Mining the Technical Roles of GitHub Users". DOI: https://doi.org/10.1016/j.infsof.2020.106485 | Technical role inference | ML study identifying GitHub developer roles; includes recruiter motivation around GitHub use. | Medium-high for technical-role taxonomy. | Add optional structured technical role/focus tags such as mobile, backend, frontend, DevOps, data, security, tooling; attach them to actual work. |
| 21 | Kalliamvakou et al., 2014, MSR, "The Promises and Perils of Mining GitHub". DOI: https://doi.org/10.1145/2597073.2597074 | GitHub data validity | Empirical MSR study on validity threats in GitHub data. | High for caution on public-profile evidence. | Public GitHub evidence is optional and incomplete. CVBuilder must summarize claimed relevance and must not treat absent public activity as negative evidence. |
| 22 | Kalliamvakou et al., 2016, Empirical Software Engineering, "An in-depth study of the promises and perils of mining GitHub". DOI: https://doi.org/10.1007/s10664-015-9393-5 | GitHub data validity | Extended empirical study on GitHub-data limitations. | High for caution on public technical traces. | Include public-evidence fields, but avoid scoring/ranking based on public traces. |
| 23 | Chavez, 2022, Social Science Research, "Racial disparities in the screening of candidates for software engineering internships". DOI: https://doi.org/10.1016/j.ssresearch.2022.102773 | Software-engineering hiring equity | Firm-level study of SE internship/full-time screening stages. | High for technical-hiring bias risk. | Keep early-career mode structured and evidence-rich; avoid adding demographic or prestige cues that are not job-relevant. |
| 24 | Chavez, 2025, Socius, "Gendered Pathways to the Job Offer". DOI: https://doi.org/10.1177/23780231251323372 | Software-engineering hiring stereotypes | Case study of software-engineering hiring and stereotype effects. | Medium-high, technical-hiring-specific. | Avoid renderer features that invite culture-fit/personality inference; emphasize concrete technical work and evidence. |
| 25 | Kumar et al., 2023, Data & Knowledge Engineering, "RINX: A system for information and knowledge extraction from resumes". DOI: https://doi.org/10.1016/j.datak.2023.102202 | Resume parsing / information extraction | End-to-end resume information extraction system. | High for parser-aware output. | Generate predictable headings and labels. Keep a single reading order and explicit fields. |
| 26 | Gaur, Saluja, Sivakumar, & Singh, 2021, Neural Computing and Applications, "Semi-supervised deep learning based named entity recognition model to parse education section of resumes". DOI: https://doi.org/10.1007/s00521-020-05351-2 | Resume parsing / education NER | NER model focused on resume education extraction. | High for education-field structure. | Render education consistently: institution, degree, field, dates, details. Do not bury education in prose. |
| 27 | Barbosa et al., 2024, Expert Systems with Applications, "Extracting section structure from resumes in Brazilian Portuguese". DOI: https://doi.org/10.1016/j.eswa.2023.122495 | Resume section structure | Resume parser focused on section and reading-order reconstruction. | High for section-ordering and parser compatibility. | CVBuilder Markdown must preserve source-order reading and explicit section headings; avoid columns/tables for core facts. |
| 28 | Gonzalez et al., 2022, Frontiers in Psychology, "Should I Trust the Artificial Intelligence to Recruit?" DOI: https://doi.org/10.3389/fpsyg.2022.895997 | Algorithmic recommendations in resume screening | Experiment with recruiters facing human/algorithm recommendations. | Medium-high for AI-in-the-loop caution. | Do not create CVBuilder-generated scores. Keep output transparent and auditable. |
| 29 | Tamkin et al., 2024, ACL, "Do Large Language Models Discriminate in Hiring Decisions on the Basis of Race, Ethnicity, and Gender?" ACL Anthology: https://aclanthology.org/2024.acl-short.37/ | LLM hiring bias | Peer-reviewed ACL short paper on LLM hiring-decision prompts. | Medium; strong warning, but LLM-screening ecosystem is moving. | Avoid unnecessary demographic cues and hidden metadata. Keep structured facts explicit so downstream systems have less room to infer from noisy cues. |
| 30 | Wilson et al., 2025, AIES, "Gender, Race, and Intersectional Bias in Resume Screening via Language Model Retrieval". AAAI/AIES: https://ojs.aaai.org/index.php/AIES/article/view/31748 | LLM retrieval / resume screening bias | Audit framework for language-model retrieval in resume screening. | Medium; peer-reviewed/emerging AI evidence. | Generated output should be stable, explicit, and low-noise. Do not add stylistic flourishes that could become spurious retrieval signals. |
| 31 | Ye et al., 2026, Information and Software Technology, "Towards bias-free recruitment: Adversarial contrastive tuning for LLM-based resume screening". DOI: https://doi.org/10.1016/j.infsof.2026.108040 | LLM resume-screening debiasing | Peer-reviewed 2026 study on LLM resume-screening fairness methods. | Medium; current and relevant but model-specific. | CVBuilder should not attempt to game LLM screeners. Focus on factual, structured, low-ambiguity Markdown. |
| 32 | arXiv, 2023, "National Origin Discrimination in Deep-learning-powered Automated Resume Screening". https://arxiv.org/abs/2307.08624 | Automated screening discrimination | Preprint on resume-screening model bias. | Low-medium; not peer-reviewed in this matrix. | Treat as a risk signal: avoid non-job-relevant origin cues and ambiguous metadata. |
| 33 | arXiv, 2026, "Small Changes, Big Impact: Demographic Bias in LLM-Based Hiring Through Subtle Sociocultural Markers in Anonymised Resumes". https://arxiv.org/abs/2603.05189 | LLM bias / subtle cues | Preprint on demographic cue effects in LLM hiring. | Low; emerging preprint. | Supports the same cautious rule: avoid decorative hobbies/affinity details unless job-relevant. |

## Matrix Notes

The GitHub issue matrix counted Pisanelli twice, once under general automated
screening and once under parser/automation implications. This checked-in matrix
keeps a single row for that paper and therefore has 33 unique source rows.

The strongest source families are:

- structured selection and biodata research
- recruiter resume-screening research
- technical developer public-evidence studies
- GitHub mining validity studies
- resume parsing / section extraction studies
- bias and demographic cue studies

## Enrichment Pass 2 (status date 2026-06-02)

Related issues: #86 (epic), #87-#94. This pass adds peer-reviewed sources found
in a second literature review, grouped by theme. The proof-grade rows, new rule
IDs (R16-R19), and rule qualifications live in <doc:ProofMatrix>. Preprints and
workshop papers are marked; one unverified DOI (Skondras 2025) and one unverified
author list (SkiLLMo 2025) must be confirmed before high-weight use.

### Accomplishment Content and Writing Quality

| # | Source | Area | Evidence / method | Strength | CVBuilder implication |
|---|---|---|---|---|---|
| 34 | Thoms et al., 1999, Journal of Business and Psychology. DOI: https://doi.org/10.1023/A:1022974232557 | Accomplishment vs duty content | Resume-characteristic study predicting interview invitations. | Medium. | Support structured accomplishment (action + outcome) fields; this is the primary anchor for R18. |
| 35 | Waung et al., 2017, Journal of Business and Psychology. DOI: https://doi.org/10.1007/s10869-016-9470-9 | Impression-management intensity | Content analysis plus controlled experiment. | Medium-high. | Render accomplishments faithfully but never auto-inflate; high-intensity self-promotion backfires. |
| 36 | Wiles, Munyikwa & Horton, 2025, Management Science. DOI: https://doi.org/10.1287/mnsc.2024.04528 | Writing clarity and outcomes | Field experiment, about 480,000 jobseekers. | High. | Optimize for readable, error-free, deterministic output over volume. |
| 37 | Tsai et al., 2011, Applied Psychology. DOI: https://doi.org/10.1111/j.1464-0597.2010.00434.x | Content relevance and fit | Field study, 216 recruiters. | High. | Prioritize role-relevant experience and education fields over exhaustive listing. |
| 38 | Sterkens et al., 2023, PLoS One. DOI: https://doi.org/10.1371/journal.pone.0283280 | Resume errors | Factorial-survey experiment, 445 recruiters. | High. | Deterministic generation prevents the error class that demonstrably lowers interview odds. |
| 39 | Petersheim et al., 2022, IEEE Transactions on Education. DOI: https://doi.org/10.1109/TE.2022.3199685 | CS-resume relevance | Recruiter vs student screening study. | Medium. | Surface high-signal technical items; do not pad. Domain-relevant to technical CVs. |

### Accessibility and Semantic Structure

| # | Source | Area | Evidence / method | Strength | CVBuilder implication |
|---|---|---|---|---|---|
| 40 | Watanabe, 2007, W4A. DOI: https://doi.org/10.1145/1243441.1243473 | Heading usability | Controlled experiment, blind and sighted users. | High. | Correct heading hierarchy is a usability good in its own right; anchors R16. |
| 41 | Williams et al., 2019, ACM TACCESS. DOI: https://doi.org/10.1145/3342282 | Linear vs tabular reading | Screen-reader look-up/synthesis experiment. | High. | Empirical (not just WCAG) backing for single reading order and no tables for core facts. |
| 42 | Silva et al., 2024, ACM TACCESS. DOI: https://doi.org/10.1145/3649223 | Headings and cognitive load | Tool plus 8-user study. | Medium-high. | Authored headings reduce cognitive load and aid structural overview. |
| 43 | Yu et al., 2025, ASSETS. DOI: https://doi.org/10.1145/3663547.3746353 | Logical ordering | 7-user restructured-HTML study. | Medium. | Predictable section ordering and clear heading labels aid comprehension. |
| 44 | Reuschel et al., 2023, JVIB. DOI: https://doi.org/10.1177/0145482X231216757 | Application-pipeline accessibility | 30 application sites, expert testers. | High (descriptive). | Structure/labeling failures are a top barrier class in the hiring pipeline. |
| 45 | Hamideh Kerdar et al., 2024, Discover Computing. DOI: https://doi.org/10.1007/s10791-024-09460-7 | Accessibility review | Scoping review. | Medium-high. | Review-tier anchor that structure and navigation are central to AT usability. |

### Current Parsing and LLM Screening

| # | Source | Area | Evidence / method | Strength | CVBuilder implication |
|---|---|---|---|---|---|
| 46 | Zhang et al., 2024, EMNLP. https://aclanthology.org/2024.emnlp-main.540/ | Reading-order extraction | ROOR benchmark; ordering relations. | High. | Correct linear reading order measurably improves extraction; strengthens R02/R11. |
| 47 | Zhang et al., 2023, EMNLP. DOI: https://doi.org/10.18653/v1/2023.emnlp-main.846 | Reading-order failure mode | Token Path Prediction; NER benchmarks. | High. | Columns/tables scramble reading order and break extraction; strengthens R11. |
| 48 | Iso et al., 2025, NAACL (Industry). DOI: https://doi.org/10.18653/v1/2025.naacl-industry.55 | LLM matching bias | Bias evaluation of LLM job-resume matching. | High. | Screeners remain biased and shifting; do not game them (R15). |
| 49 | Skondras et al., 2025, Electronics (MDPI). DOI: 10.3390/electronics14244960 (unverified) | Structured prompting | Zero-shot resume-job matching via segmentation. | Medium. | Downstream pipelines normalize input into structured segments; mild support for R01. |

### Skills Representation

| # | Source | Area | Evidence / method | Strength | CVBuilder implication |
|---|---|---|---|---|---|
| 50 | Zhang et al., 2022, NAACL. DOI: https://doi.org/10.18653/v1/2022.naacl-main.366 | Skill extraction | SkillSpan corpus and baselines. | High. | Treat skills as discrete typed entities (hard vs soft). |
| 51 | Zhang et al., 2023, ACL. DOI: https://doi.org/10.18653/v1/2023.acl-long.662 | Taxonomy normalization | ESCOXLM-R multilingual pretraining. | High. | Optional normalized skill identifier (ESCO) makes skills machine-comparable. |
| 52 | SkiLLMo, 2025, ACM SAC. DOI: https://doi.org/10.1145/3672608.3707960 (authors unverified) | ESCO normalization | Extraction plus taxonomy matching. | Medium. | Corroborates that standardization to a taxonomy is a distinct valuable step. |
| 53 | Bone, Gonzalez Ehlinger & Stephany, 2025, Technological Forecasting and Social Change. DOI: https://doi.org/10.1016/j.techfore.2025.124042 | Skills-based hiring | about 11M UK vacancies. | High. | Modern technical hiring foregrounds specific skills tied to roles over credentials. |
| 54 | Gugnani & Misra, 2020, AAAI. DOI: https://doi.org/10.1609/aaai.v34i08.7038 | Contextual skills | Implicit skill inference for matching. | High. | Contextual skills tied to work beat detached lists by about 29.4%; backs R14/R06. |
| 55 | Decorte et al., 2023, RecSys-in-HR workshop. arXiv 2310.15636 (workshop) | Career representation | Hybrid skill plus work-context model. | Medium. | Keep a structured skills surface and anchor skills in work context. |

### Employment Gaps and Date Presentation

| # | Source | Area | Evidence / method | Strength | CVBuilder implication |
|---|---|---|---|---|---|
| 56 | Kristal et al., 2022, Nature Human Behaviour. DOI: https://doi.org/10.1038/s41562-022-01485-6 | Dates vs duration framing | Pre-registered audit, N=9,022 plus labs. | High. | Offer a duration-based period mode; do not auto-expose gaps; anchors R17. |
| 57 | Kroft, Lange & Notowidigdo, 2013, Quarterly Journal of Economics. DOI: https://doi.org/10.1093/qje/qjt015 | Gap-length penalty | about 12,000-resume field experiment. | High. | Visible gap length is the penalized signal; default away from gap-revealing precision. |
| 58 | Bateson, 2023, PLOS ONE. DOI: https://doi.org/10.1371/journal.pone.0281449 | Gap penalty | Pre-registered vignette, 974 adults. | Medium-high. | Penalty attaches to the gap's existence, not its cause; the renderer lever is presentation. |
| 59 | Namingit, Blankenau & Schwab, 2021, Journal of Economic Behavior and Organization. DOI: https://doi.org/10.1016/j.jebo.2020.09.033 | Gap cause/disclosure | Resume audit with illness gap. | Medium-high. | Do not auto-render leave reasons; enriches R10. |

### Localization and Name Handling

| # | Source | Area | Evidence / method | Strength | CVBuilder implication |
|---|---|---|---|---|---|
| 60 | Adamovic & Leibbrandt, 2023, The Leadership Quarterly. DOI: https://doi.org/10.1016/j.leaqua.2022.101655 | Name-origin bias | 12,000+ Australian applications. | High. | Localizing must not add origin signals (nationality, photo, transliteration). |
| 61 | Krause, Rinne & Zimmermann, 2012, IZA Journal of European Labor Studies. DOI: https://doi.org/10.1186/2193-9012-1-5 | Anonymous applications | Synthesis of European experiments. | Medium-high. | Keep photo/DOB/nationality/marital-status opt-in and off by default. |
| 62 | Sousa, Campos & Jorge, 2023, CIKM. DOI: https://doi.org/10.1145/3583780.3615130 | Locale date parsing | Multilingual temporal-expression models. | High. | Emit ISO 8601 machine value plus optional localized display; avoid ambiguous numeric dates. |
| 63 | Mishra, He & Belli, 2020, AKBC workshop. arXiv 2008.03415 (workshop) | NER name bias | Demographic-name NER evaluation. | Medium-high. | Put the name in a fixed slot; do not rely on a parser recognizing the name string. |
| 64 | Kesim & Deliahmetoglu, 2023. arXiv 2306.13062 (preprint) | Non-English resume NER | Turkish IT-resume NER. | Medium. | Keep date/degree/title/country/language as discrete delimited fields. |
| 65 | Loessberg-Zahl, 2024. arXiv 2401.12941 (preprint) | Multicultural name detection | Name recognizer across 103 countries. | Medium. | Reinforces a structurally privileged name slot over morphology-based detection. |

### Recruiter Attention and Ordering

| # | Source | Area | Evidence / method | Strength | CVBuilder implication |
|---|---|---|---|---|---|
| 66 | Osanami Torngren et al., 2024, Frontiers in Sociology. DOI: https://doi.org/10.3389/fsoc.2024.1222850 | Eye-tracking | 40 recruiters, 200 CV-views. | High. | Dwell-time does not predict the decision; top placement is a sensible default, not a causal lever. |
| 67 | Highhouse & Gallo, 1997, Human Performance. DOI: https://doi.org/10.1207/s15327043hup1001_2 | Serial-position effects | Controlled order-manipulation experiment. | High. | Order-effect direction is task-dependent (often recency); R03/R04 are heuristics, not primacy guarantees. |
| 68 | Fousiani, Van Prooijen & Armenta, 2022, Frontiers in Psychology. DOI: https://doi.org/10.3389/fpsyg.2022.923329 | Context-dependent weighting | 260 recruiters plus 2 experiments. | High (verified), weak as ordering evidence. | Which section matters most is employer-dependent; undercuts any universal fixed order. |
