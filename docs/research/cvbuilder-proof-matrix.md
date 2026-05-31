# CVBuilder Proof Matrix

Status date: 2026-05-31

Related issues: #11, #5, #3

This document completes the proof-grade audit requested in #11. It verifies the
main CVBuilder technical-CV rules against source-level evidence, and marks weak
or purely pragmatic rules as such.

This is not a claim that a CV can be made into a valid selection instrument.
The strongest personnel-selection literature says the opposite: resumes are
limited and bias-prone. CVBuilder's defensible role is narrower: keep CV data
structured and render a clear, factual, low-noise Markdown artifact.

## Evidence Sources

Rows below include method, population/sample, relevant finding, limitation, and
the CVBuilder rule IDs supported.

Rule IDs are listed in the next section.

| Source ID | Source | Method / sample / population | Relevant finding for CVBuilder | Limitations | Rule IDs |
|---|---|---|---|---|---|
| E01 | Schmidt & Hunter, 1998, Psychological Bulletin. DOI: https://doi.org/10.1037/0033-2909.124.2.262 | Meta-analytic summary of personnel-selection research across 85 years and multiple selection procedures. | Selection validity depends on validated selection methods; resumes should not be treated as scoring instruments. | Broad selection-method evidence, not CV-renderer-specific. | R09, R15 |
| E02 | Sackett, Zhang, Berry, & Lievens, 2022, Journal of Applied Psychology. DOI: https://doi.org/10.1037/apl0000994 | Meta-analytic reassessment of personnel-selection validity estimates. | Validity estimates can be sensitive to correction assumptions; selection claims need caution. | Selection-method evidence, not resume-format evidence. | R09, R15 |
| E03 | Risavy, Robie, Fisher, & Rasheed, 2022, Frontiers in Psychology. DOI: https://doi.org/10.3389/fpsyg.2022.884205 | Peer-reviewed argument grounded in personnel-selection and application-form literature. | Resumes lack comparable structured data; application forms provide standardized fields. | Perspective article, not a new experiment. | R01, R09, R10 |
| E04 | Brown & Campion, 1994, Journal of Applied Psychology. DOI: https://doi.org/10.1037/0021-9010.79.6.897 | Empirical biodata/recruiter interpretation study. Population: recruiters/evaluators judging biographical information. | Recruiters interpret biographical facts; structured facts should be explicit and separated from style. | Older study; not technical-CV-specific. | R01, R09 |
| E05 | Cole, Rubin, Feild, & Giles, 2007, Applied Psychology. DOI: https://doi.org/10.1111/j.1464-0597.2007.00288.x | Empirical study of recruiter use of resume information. Population: recruiters screening recent-graduate resumes. | Recruiters use resume facts to form screening judgments; job-relevant facts need predictable placement. | Recent-graduate setting; not senior technical candidates. | R02, R03, R13 |
| E06 | Cole, Feild, Giles, & Harris, 2009, Journal of Business and Psychology. DOI: https://doi.org/10.1007/s10869-008-9086-9 | Empirical study of personality inferences from resumes. Population: recruiters/evaluators. | Recruiters infer personality from resumes, but resume artifacts are weak for personality measurement. | Supports caution, not a layout recipe. | R09, R10 |
| E07 | Apers & Derous, 2017, Computers in Human Behavior. DOI: https://doi.org/10.1016/j.chb.2017.02.063 | Empirical recruiter study comparing paper and video resume personality judgments. | Richer media did not make recruiter personality judgments reliably accurate. | Focuses on personality judgment, not technical hiring. | R09, R10 |
| E08 | Wright, Domagalski, & Collins, 2011, Business Communication Quarterly. DOI: https://doi.org/10.1177/1080569911413809 | Resume-format study involving structured additions to resume presentation. | More structured resume formats can improve evaluation consistency. | Medium confidence; not technical-CV-specific and not enough alone for rule proof. | R01, R02 |
| E09 | Pina et al., 2023, Machine Learning and Knowledge Extraction. DOI: https://doi.org/10.3390/make5030038 | Eye-tracking / machine-learning study on computer-science resumes. Population: recruiters evaluating CS resumes. | Experience and education attention were meaningful in recruiter approval prediction. | Computer-science resume study, but still limited sample/context. | R02, R03, R04, R13 |
| E10 | Bertrand & Mullainathan, 2004, American Economic Review. DOI: https://doi.org/10.1257/0002828042002561 | Resume audit field experiment. Population: employers receiving randomized fictitious resumes. | Otherwise comparable resumes received different callback rates when names signaled race. | US labor-market setting and name-signal design. | R10 |
| E11 | Derous & Decoster, 2017, Frontiers in Psychology. DOI: https://doi.org/10.3389/fpsyg.2017.01321 | Internet resume-screening experiment with 610 frequent recruiters/raters. | Implicit age cues affected hiring-related ratings. | Project-manager scenario; not technical-CV-specific. | R10 |
| E12 | Kang, DeCelles, Tilcsik, & Jun, 2016, Administrative Science Quarterly. DOI: https://doi.org/10.1177/0001839216639577 | Interviews, lab experiment, and resume audit study on resume whitening. | Race-associated resume cues affected applicant self-presentation and employer response. | Focuses on racialized self-presentation; not renderer mechanics. | R10 |
| E13 | Oreopoulos, 2011, American Economic Journal: Economic Policy. DOI: https://doi.org/10.1257/pol.3.4.148 | Field experiment sending about 13,000 randomized resumes to Toronto job postings. | Foreign experience and non-English names reduced callbacks in multiple occupations. | Canadian/Toronto labor-market context. | R10 |
| E14 | Pisanelli, 2022, Economics Letters. DOI: https://doi.org/10.1016/j.econlet.2022.110892 | Field study of automated resume screening and gender gaps. | Automated screening can have measurable distributional effects. | Automation context is system-specific. | R02, R10, R15 |
| E15 | Buijsrogge, Derous, & Duyck, 2016, Human Performance. DOI: https://doi.org/10.1080/08959285.2016.1165225 | Stigma / initial-reaction study in hiring-related judgment. | Early subjective impressions can be biased and overconfident. | Adjacent interview-stage evidence, not resume-specific. | R09, R10 |
| E16 | Kuttal et al., 2021, Information and Software Technology. DOI: https://doi.org/10.1016/j.infsof.2021.106633 | Scenario-based evaluation with 10 participants comparing GitHub, Stack Overflow, and Visual Resume. | Aggregated summaries helped evaluators inspect more technical/social-skill cues with lower effort. | Small scenario study; not a field hiring outcome. | R06, R07, R08, R14 |
| E17 | Marlow, Dabbish, & Herbsleb, 2013, CSCW. DOI: https://doi.org/10.1145/2441776.2441792 | Qualitative study of impression formation from GitHub profiles/activity traces. | Activity traces shape impressions of expertise and collaboration. | Impression study; not a validation study for hiring outcomes. | R07, R08, R14 |
| E18 | Li, Ko, & Zhu, 2015, ICSE. DOI: https://doi.org/10.1109/ICSE.2015.335 | Empirical study of attributes of great software engineers. Population: software-engineering practitioners. | Software-engineering excellence includes judgment, learning, collaboration, and impact beyond tools. | Studies expertise attributes, not CV screening directly. | R06, R14 |
| E19 | Hauff & Gousios, 2015, MSR. DOI: https://doi.org/10.1109/MSR.2015.41 | Mining-software-repositories study matching GitHub profiles to job ads. | Technology/profile concepts can be extracted and matched, but are approximations. | GitHub-profile data is incomplete and public-activity biased. | R06, R08, R14 |
| E20 | Baltes & Diehl, 2021, Information and Software Technology. DOI: https://doi.org/10.1016/j.infsof.2020.106485 | Machine-learning study with ground truth of 2,284 GitHub developers labeled in six roles; also inspected 5,027 Stack Overflow Jobs posts. | Technical roles are identifiable and common in job ads; role tags can describe technical focus. | GitHub population and role taxonomy may not cover all candidates. | R06, R14 |
| E21 | Kalliamvakou et al., 2014, MSR. DOI: https://doi.org/10.1145/2597073.2597074 | Empirical study of validity threats in GitHub data mining. | GitHub data is incomplete and easy to misinterpret. | Repository-platform-specific. | R08, R15 |
| E22 | Kalliamvakou et al., 2016, Empirical Software Engineering. DOI: https://doi.org/10.1007/s10664-015-9393-5 | Extended empirical study of GitHub mining validity threats. | Public GitHub traces should not be treated as complete measures of developer ability. | Platform-specific and not a hiring-outcome study. | R08, R15 |
| E23 | Chavez, 2022, Social Science Research. DOI: https://doi.org/10.1016/j.ssresearch.2022.102773 | Firm-level study of screening for software-engineering internships. | Early-career software-engineering screening has racial disparities and less information than full-time hiring. | One firm/context; focuses on internship screening. | R04, R10 |
| E24 | Chavez, 2025, Socius. DOI: https://doi.org/10.1177/23780231251323372 | Mixed qualitative/quantitative case study of software-engineering offer decisions. | Culture fit, technical ability, and diversity-value stereotypes affect SE hiring decisions. | One organizational setting; offer-stage rather than resume-renderer study. | R09, R10 |
| E25 | Kumar et al., 2023, Data & Knowledge Engineering. DOI: https://doi.org/10.1016/j.datak.2023.102202 | End-to-end resume information extraction system for resumes in multiple formats. | Resumes vary widely in format/style/content; extraction aims to convert unstructured resumes into structured information. | System/deployment paper; exact generalization depends on parser. | R01, R02, R11, R12 |
| E26 | Gaur, Saluja, Sivakumar, & Singh, 2021, Neural Computing and Applications. DOI: https://doi.org/10.1007/s00521-020-05351-2 | Semi-supervised deep-learning NER model for education sections; reported 92.06% NER performance. | Even education extraction benefits from explicit structure and labels. | Focuses on education section extraction. | R02, R11 |
| E27 | Barbosa et al., 2024, Expert Systems with Applications. DOI: https://doi.org/10.1016/j.eswa.2023.122495 | Resume parser for Brazilian Portuguese with reading-order recovery and section/subsection extraction. | Correct reading order and section reconstruction are central resume-parsing problems. | Portuguese/PDF-parser context; applies by inference to Markdown output. | R02, R11 |
| E28 | Gonzalez et al., 2022, Frontiers in Psychology. DOI: https://doi.org/10.3389/fpsyg.2022.895997 | Experiment on recruiter trust in algorithmic recommendations. | AI-in-the-loop screening raises trust and decision-process concerns. | Not a CV-format study. | R09, R15 |
| E29 | Tamkin et al., 2024, ACL. https://aclanthology.org/2024.acl-short.37/ | Peer-reviewed ACL short paper using templated prompts to test LLM hiring decisions. | Some LLM hiring outputs can vary with race/ethnicity/gender name signals. | Prompt/model dependent; not proof about all systems. | R10, R15 |
| E30 | Wilson & Caliskan, 2024, AIES. https://ojs.aaai.org/index.php/AIES/article/view/31748 | Resume audit framework for language-model retrieval in screening scenarios. | Language-model retrieval can show gender/race/intersectional bias in resume-screening tasks. | Retrieval-model-specific and emerging area. | R10, R15 |
| E31 | Ye et al., 2026, Information and Software Technology. DOI: https://doi.org/10.1016/j.infsof.2026.108040 | LLM resume-screening fairness/debiasing study. | Model-specific screening behavior requires caution; fairness work is ongoing. | Current/emerging model-specific evidence. | R10, R15 |

## Rule Decisions

| Rule ID | Rule | Decision | Directness | Evidence | Implementation action |
|---|---|---|---|---|---|
| R01 | Structured JSON/CVDocument should be canonical; Markdown should be generated. | Keep | Direct and adjacent | E03, E04, E08, E25 | Implement `CVDocument` as canonical data and Markdown as deterministic output. |
| R02 | Technical CV output should use one source-order reading path. | Keep | Direct for parser structure, adjacent for Markdown | E05, E09, E25, E26, E27 | Renderer must emit one source-order Markdown flow with predictable headings. |
| R03 | Experienced technical candidates should lead with experience. | Revise | Adjacent | E05, E09 | Make this the experienced technical default, not a universal rule. |
| R04 | Early-career technical candidates may need education/projects earlier. | Keep as inference | Inferred from early-career screening evidence | E05, E09, E23 | Provide an early-career rendering option. |
| R05 | Projects/products should nest under the job where the work happened. | Keep as pragmatic structure | Pragmatic, evidence-informed | E05, E16, E25, E27 | Keep nested project rendering, but mark as information-architecture default rather than proven hiring effect. |
| R06 | Technologies should be attached to concrete roles/projects, not only global skills. | Keep | Direct/adjacent technical evidence | E16, E18, E19, E20 | Add technologies to role/project/public evidence models and render near the work. |
| R07 | Public technical evidence should include a summary, not only a link. | Keep | Direct technical evidence | E16, E17 | Add structured public evidence summary fields. |
| R08 | Public developer traces should not be scored. | Keep | Direct caution evidence | E19, E21, E22 | Do not score GitHub/Stack Overflow/public evidence; render summaries only. |
| R09 | CVBuilder should not render skill bars, fit scores, personality labels, or culture-fit labels. | Keep | Direct for scoring/personality caution, pragmatic for UI forms | E01, E02, E03, E06, E07, E15, E24, E28 | Prohibit renderer-generated scores, bars, personality labels, and culture-fit labels. |
| R10 | CVBuilder should avoid photos/icons/demographic metadata by default. | Keep | Direct for demographic cue caution | E10, E11, E12, E13, E14, E23, E24, E29, E30, E31 | Do not render photos, icon-only semantic labels, age, birthdate, nationality, marital status, or decorative demographic metadata by default. |
| R11 | CVBuilder should avoid tables/columns/images for core facts unless parser tests prove safety. | Keep with test escape hatch | Direct parser evidence plus pragmatic Markdown rule | E25, E26, E27 | Keep core facts in plain headings/paragraphs/lists until parser tests explicitly support tables or columns. |
| R12 | Markdown escaping and deterministic rendering should be required. | Keep as engineering invariant | Pragmatic engineering, indirectly parser-supported | E25, E27 | Treat escaping/determinism as correctness requirements, not as scientific hiring claims. |
| R13 | Global skills should stay compact and grouped near the end. | Downgrade to pragmatic | Weak/inferred | E05, E09 | Keep as default renderer style, but do not call it evidence-backed. |
| R14 | Technical area/focus tags should attach to actual work, not become keyword stuffing. | Keep | Direct/adjacent technical evidence | E16, E18, E19, E20 | Add role/project technical-area tags and render them near the relevant work. |
| R15 | CVBuilder should not optimize for a specific ATS/LLM; it should emit factual, low-noise, auditable Markdown. | Keep | Adjacent/emerging | E01, E02, E14, E21, E22, E28, E29, E30, E31 | Avoid ATS/LLM-specific scoring or gaming. Emit explicit, factual Markdown. |

## Contradiction And Downgrade Log

- R05 is useful information architecture, but no source directly proves that
  nesting projects under jobs improves hiring outcomes. It remains as a
  pragmatic renderer default.
- R12 is not a scientific hiring rule. Escaping and determinism are engineering
  correctness requirements.
- R13 is weakly supported. Skills should be visible, but "near the end" is a
  renderer convention, not a proven scientific rule.
- R15 is supported by cautionary AI-screening and validity evidence, but
  specific ATS/LLM behavior changes quickly. The stable rule is not to game
  systems.

Rejected folklore:

- No source in this audit justifies a strict one-page rule.
- No source in this audit justifies the common "six seconds" rule as an
  implementation requirement.
- No source in this audit proves that all tables are rejected by all ATS tools.
  The defensible rule is narrower: keep core facts out of layout-dependent
  structures unless parser tests prove safety.
- No source in this audit supports keyword stuffing over contextual evidence.

## Final Surviving Rule Set For #3

Evidence-backed or evidence-informed:

- Structured `CVDocument` data is canonical; Markdown is generated.
- Use one source-order Markdown reading path.
- Experienced technical mode leads with experience; early-career mode can move
  education/projects earlier.
- Attach technologies and technical areas to concrete roles/projects.
- Public technical evidence includes a concise summary and link.
- Public developer traces are optional and never scored.
- Do not render skill bars, fit scores, personality labels, culture-fit labels,
  or inferred seniority scores.
- Avoid photos, icon-only semantic labels, and demographic metadata by default.
- Keep core facts out of tables/columns/images unless parser tests prove safety.
- Do not optimize for a specific ATS/LLM; emit factual, low-noise Markdown.

Pragmatic engineering requirements:

- Escape generated Markdown text and link destinations.
- Keep rendering deterministic.
- Omit empty sections.
- Keep global skills compact and grouped by default.
- Nest projects/products under jobs by default when they are work performed in
  that role.
