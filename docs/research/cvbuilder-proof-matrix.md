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

## Enrichment Pass 2 (status date 2026-06-02)

Related issues: #86 (epic), #87, #88, #89, #90, #91, #92, #93, #94.

This section extends the proof matrix with a second proof-grade literature pass.
It does not rewrite the E01-E31 rows or the original R01-R15 decisions above; it
adds new evidence (E32 onward), new rules (R16-R19), and qualifications to
existing rules. Preprints and any unverified DOIs are marked and must be
confirmed before they are treated as high-weight proof.

### New Evidence Sources

| Source ID | Source | Method / sample / population | Relevant finding for CVBuilder | Limitations | Rule IDs |
|---|---|---|---|---|---|
| E32 | Thoms, McMasters, Roberts & Dombkowski, 1999, Journal of Business and Psychology. DOI: https://doi.org/10.1023/A:1022974232557 | Empirical study of resume characteristics predicting interview invitations for graduating students. | Resumes with accomplishment statements drew more favorable interview-invitation outcomes than duty-only resumes. | Old; graduate population; accomplishment content generally, not numeric quantification. | R18 |
| E33 | Waung, McAuslan, DiMambro & Miego, 2017, Journal of Business and Psychology. DOI: https://doi.org/10.1007/s10869-016-9470-9 | Content analysis of 60 resumes plus a controlled impression-management experiment. | Moderate-intensity self-promotion (accomplishment claims) improved perceived fit; high-intensity did not (backfire ceiling). | MTurk raters; cover letters bundled; fit perception not a hard decision. | R18 |
| E34 | Wiles, Munyikwa & Horton, 2025, Management Science. DOI: https://doi.org/10.1287/mnsc.2024.04528 | Field experiment, about 480,000 jobseekers randomized to algorithmic writing assistance. | More readable, error-free resumes raised hiring 8% at 10% higher wages; the lever was clarity, not added volume. | Online gig-labor context; assistance bundles several edits. | R02, R12 |
| E35 | Tsai, Chi, Huang & Hsu, 2011, Applied Psychology. DOI: https://doi.org/10.1111/j.1464-0597.2010.00434.x | Field study, 216 organizational recruiters, campus recruitment. | Relevant experience and education raise hiring recommendations via perceived fit; relevance drives it, not amount of text. | Self-report fit; Taiwan campus context; length not manipulated. | R02 |
| E36 | Sterkens, Caers, De Couck, Van Driessche, Geamanu & Baert, 2023, PLoS One. DOI: https://doi.org/10.1371/journal.pone.0283280 | Factorial-survey experiment, 445 recruiters, 1,335 resumes. | Five spelling errors cut interview probability 18.5pp; two errors 7.3pp. Content correctness matters sharply. | Studies errors not length; vignette design. | R12 |
| E37 | Petersheim, Lahey, Cherian et al., 2022, IEEE Transactions on Education. DOI: https://doi.org/10.1109/TE.2022.3199685 | Comparative CS-resume screening study, recruiters vs students. | Recruiters correctly weight relevant items; item relevance, not bulk, governs CS-resume judgment. | Education framing; paywalled full text; length not isolated. | R02, R03 |
| E38 | Watanabe, 2007, W4A. DOI: https://doi.org/10.1145/1243441.1243473 | Controlled experiment, blind and sighted screen-reader users, information-finding tasks. | Proper heading markup significantly reduced task-completion time and raised satisfaction for both groups. | Older; web HTML context; experienced users compensate. | R16 |
| E39 | Williams, Clarke, Gardiner, Zimmerman & Tomasic, 2019, ACM TACCESS. DOI: https://doi.org/10.1145/3342282 | Controlled screen-reader experiment on look-up and synthesis tasks. | Predictable linear presentation beat tabular-read-linearly on navigation speed and accuracy. | Lab tasks; modest sample typical of AT studies. | R11, R16 |
| E40 | Silva, Cardoso, De Bettio, Tavares, Silva, Watanabe & Freire, 2024, ACM TACCESS. DOI: https://doi.org/10.1145/3649223 | Tool generating headers/navigation; user study with 8 screen-reader users. | Headers and internal navigation are vital for grasping structure; generated headings reduced cognitive load (preliminary). | Preliminary indicators; auto-generated headings. | R16 |
| E41 | Yu, Ryskeldiev, Tsutsui, Gillingham & Wang, 2025, ASSETS. DOI: https://doi.org/10.1145/3663547.3746353 | 7 screen-reader users comparing original vs restructured HTML. | Logical section ordering and summary headings improved navigation and comprehension of hierarchy. | n=7; e-commerce domain. | R16 |
| E42 | Reuschel, McDonnall & Burton, 2023, JVIB. DOI: https://doi.org/10.1177/0145482X231216757 | 3 expert blind testers, 30 Fortune-500 application sites, 90 attempts. | About 75% of issues were structure/labeling ("information and relationships"); the hiring pipeline is materially inaccessible. | Application forms not CV docs; n=3 experts. | R16 |
| E43 | Hamideh Kerdar, Bachler & Kirchhoff, 2024, Discover Computing. DOI: https://doi.org/10.1007/s10791-024-09460-7 | Scoping review of digital accessibility for blind/low-vision users. | Confirms structure and navigation as central to screen-reader usability. | Scoping review; not CV-specific. | R16 |
| E44 | Zhang, Tu, Zhao et al., 2024, EMNLP 2024. https://aclanthology.org/2024.emnlp-main.540/ (arXiv 2409.19672) | ROOR benchmark; reading order as ordering relations injected into IE models. | Correct reading order improved extraction across 3 models and 8 cross-domain document IE/QA settings. | Visually-rich documents broadly, not resumes specifically. | R02, R11 |
| E45 | Zhang, Guo, Tu et al., 2023, EMNLP 2023. DOI: https://doi.org/10.18653/v1/2023.emnlp-main.846 | Token Path Prediction; two revised real-world NER benchmarks on scanned documents. | Sequence-labeling extraction fails when reading order is scrambled; columns/tables are the canonical scrambler. | Scanned OCR setting; resumes a subset. | R02, R11 |
| E46 | Iso, Pezeshkpour, Bhutani & Hruschka, 2025, NAACL 2025 (Industry). DOI: https://doi.org/10.18653/v1/2025.naacl-industry.55 | Evaluation of LLM job-resume matching for gender/race/education bias. | Explicit-attribute bias reduced in recent models, but implicit education-based bias persists. | Demographic bias focus; no format manipulation. | R15 |
| E47 | Skondras, Zervas & Tzimas, 2025, Electronics (MDPI). DOI: 10.3390/electronics14244960 [UNVERIFIED DOI] | Chain-of-thought structured prompting for zero-shot resume-job matching. | Structuring/segmenting resume and job post before matching enabled effective zero-shot matching (up to about 87% for some occupations). | MDPI venue; single open model; DOI not confirmed. | R01 |
| E48 | Zhang, Jensen, Sonniks & Plank, 2022, NAACL 2022. DOI: https://doi.org/10.18653/v1/2022.naacl-main.366 | SkillSpan corpus; 14.5K sentences, hard/soft skill spans; BERT baselines. | Skills are extractable structured spans (hard vs soft), but need domain-adapted models. | English job postings, not CVs; extraction not normalization. | R06, R14 |
| E49 | Zhang, van der Goot & Plank, 2023, ACL 2023. DOI: https://doi.org/10.18653/v1/2023.acl-long.662 | ESCOXLM-R; ESCO-taxonomy-driven multilingual pretraining; 9 datasets, 4 languages. | Injecting the ESCO taxonomy set state of the art on skill identification; taxonomy normalization aids machine processing across languages. | Model-side; job-ad domain; benchmark not hiring outcomes. | R13, R19 |
| E50 | SkiLLMo, 2025, ACM SAC 2025. DOI: https://doi.org/10.1145/3672608.3707960 [authors UNVERIFIED] | BERT segment filter + LLM extraction + ESCO normalization; expert evaluation. | 91% extraction precision, 80% standardization precision; normalization to ESCO is a distinct valuable step. | DOI verified; author list not confirmed; conference. | R13 |
| E51 | Bone, Gonzalez Ehlinger & Stephany, 2025, Technological Forecasting and Social Change. DOI: https://doi.org/10.1016/j.techfore.2025.124042 | Time-series analysis of about 11M UK vacancies, 2018-2024. | AI roles mention specific skills about 3x more than qualifications; degree requirements fell about 15%. | UK only; AI/green segments; posting language not hires. | R06, R14 |
| E52 | Gugnani & Misra, 2020, AAAI. DOI: https://doi.org/10.1609/aaai.v34i08.7038 | Doc2Vec over 1.1M postings; explicit vs implicit (contextual) skills for resume-job matching. | Adding implicit skills inferred from work context raised matching 29.4% over explicit-only lists. | Single-organization system; MRR proxy not hire success. | R14, R06 |
| E53 | Decorte, Van Hautte, Deleu, Develder & Demeester, 2023, RecSys-in-HR 2023 workshop. arXiv 2310.15636 [workshop] | 2,164 ESCO-labeled career histories; skill-based vs text-based vs hybrid. | Hybrid skill + work-context representation (43.0% recall@10) beat skill-only (35.2%) and text-only (39.6%). | Workshop tier; small dataset; prediction task. | R06, R13 |
| E54 | Kristal, Nicks, Gloor & Hauser, 2022, Nature Human Behaviour. DOI: https://doi.org/10.1038/s41562-022-01485-6 | Pre-registered UK audit field experiment, N=9,022 applications, plus 2 lab studies. | Listing roles by years worked instead of start-end dates raised callbacks for applicants with career breaks (about +4.9pp vs unexplained gap, +2.9pp vs a no-gap dated resume); mechanism was better recall of accumulated experience. | UK; entry/return roles; does not isolate month vs year granularity. | R17 |
| E55 | Kroft, Lange & Notowidigdo, 2013, Quarterly Journal of Economics. DOI: https://doi.org/10.1093/qje/qjt015 | Resume field experiment, about 12,000 resumes to about 3,000 US openings. | Callback falls sharply with visible unemployment-spell length, most within the first 8 months. | 2008-2011 recession-era US; spell length explicit by design. | R17 |
| E56 | Bateson, 2023, PLOS ONE. DOI: https://doi.org/10.1371/journal.pone.0281449 | Pre-registered vignette experiment, 974 US adults, hospitality profiles. | An employment break cut selection about 20% and lowered trait ratings, with no meaningful difference by gap type (penalty attaches to existence, not cause). | Survey experiment; single sector; no date-format manipulation. | R17 |
| E57 | Namingit, Blankenau & Schwab, 2021, Journal of Economic Behavior & Organization. DOI: https://doi.org/10.1016/j.jebo.2020.09.033 | Randomized resume audit varying an illness-explained gap vs unexplained vs none. | Explaining a gap helps partially but still penalized; introduces a separate health-disclosure penalty. | Illness/cancer framing; US; full text gated. | R10, R17 |
| E58 | Adamovic & Leibbrandt, 2023, The Leadership Quarterly. DOI: https://doi.org/10.1016/j.leaqua.2022.101655 | Correspondence field experiment, 12,000+ Australian applications across 6 name groups. | Non-English-named applicants received 57.4% fewer leadership callbacks holding content constant. | Australian market; callback not hire; pre-application stage. | R10, R19 |
| E59 | Krause, Rinne & Zimmermann, 2012, IZA Journal of European Labor Studies. DOI: https://doi.org/10.1186/2193-9012-1-5 | Synthesis of European anonymous-application field experiments. | Removing name/photo/nationality can equalize interview chances; net effects context-dependent. | Older; mixed effects; some component studies small. | R10, R19 |
| E60 | Sousa, Campos & Jorge, 2023, CIKM 2023. DOI: https://doi.org/10.1145/3583780.3615130 | TEI2GO; temporal-expression identification across 6 languages. | Locale date disambiguation (for example 03/10/2022) is a known, language-specific failure mode. | Identification emphasis; news-domain corpora not resumes. | R19 |
| E61 | Mishra, He & Belli, 2020, AKBC workshop. arXiv 2008.03415 [workshop] | NER evaluated on synthetic name corpora across demographic groups. | NER accuracy is systematically lower for some name groups; underrepresented names are disproportionately dropped. | Synthetic corpora; pre-LLM models; workshop. | R19 |
| E62 | Kesim & Deliahmetoglu, 2023. arXiv 2306.13062 [preprint] | Six transformer models for NER on Turkish IT resumes; 8 entity types. | Non-English resume NER is feasible at usable accuracy with language-adapted models when fields are discrete. | Single language/sector; preprint. | R19 |
| E63 | Loessberg-Zahl, 2024. arXiv 2401.12941 [preprint] | English name recognizer; data/input ablations; names from 103 countries. | Char+word embeddings outperform on unseen non-Western names; detection is structure-dependent. | Single architecture; English-centric; preprint. | R19 |
| E64 | Osanami Torngren, Schutze, Van Belle & Nystrom, 2024, Frontiers in Sociology. DOI: https://doi.org/10.3389/fsoc.2024.1222850 | Eye-tracking vignette, 40 Swedish recruiters, 200 CV-views. | Dwell-time did not correlate with CV ratings; where recruiters looked longest did not predict choice. | Small N; finance/retail not tech; ordering not manipulated. | R02, R03, R13 |
| E65 | Highhouse & Gallo, 1997, Human Performance. DOI: https://doi.org/10.1207/s15327043hup1001_2 | Controlled experiment, 117 raters, manipulated information order. | Recency, not primacy, predominated in this evaluative task; order-effect direction is task-dependent. | Older; student raters; behavioral episodes not CV sections. | R03, R04 |
| E66 | Fousiani, Van Prooijen & Armenta, 2022, Frontiers in Psychology. DOI: https://doi.org/10.3389/fpsyg.2022.923329 | 260 recruiters plus two preregistered experiments. | Which attribute carries weight is context-dependent (competence vs morality by org goal). | Order controlled away, not tested; framing evidence only. | R03, R13 |

### New Rules

| Rule ID | Rule | Decision | Directness | Evidence | Implementation action |
|---|---|---|---|---|---|
| R16 | Accessible, semantically-structured output (one top-level heading, strictly non-skipping heading levels, single linear reading order, no tables/columns/images for core facts) is a first-class human-accessibility concern, distinct from parser rules R02/R11. | Keep as design principle | Direct for document structure, inferred for CVs specifically | E38, E39, E40, E41, E42, E43 | Emit exactly one `#` title, non-skipping `#`/`##`/`###`/`####`, list semantics for enumerable facts, single source-order path; satisfy WCAG 2.x SC 1.3.1, 1.3.2, 2.4.6, 2.4.10 as a normative (not evidentiary) baseline. Add a renderer test for single `#` and no level skips. |
| R17 | Date/period rendering: default to year-level granularity, never auto-compute or expose inter-role gaps, optionally support a duration-based period mode. | Keep as renderer-determinism rule | Direct (date/duration presentation manipulated) | E54, E55, E56, E57 | Default role dates to year level (`2019 - 2022`); never derive gap markers, between-role durations, or unemployment spans; support an optional `Org (3 yrs), Title` mode from the typed document. Month-level remains representable on explicit request. |
| R18 | Support structured results-oriented accomplishment fields and render them faithfully; never auto-inflate or invent metrics. | Keep; quantification sub-claim marked unproven | Adjacent | E32, E33 | Add an `accomplishments` affordance (action + outcome); render user-supplied outcomes verbatim; no auto-superlativizing or fabricated numbers. Do not pressure users to add numbers; numeric-quantification effect is unsupported. |
| R19 | Localized output stays taxonomy-mappable (stable canonical heading tokens), keeps the name in a fixed structural slot, emits ISO 8601 date machine values, and keeps origin-revealing fields opt-in/off by default. | Keep as engineering inference | Adjacent (assembled from parsing and labor-economics evidence) | E49, E58, E59, E60, E61, E62, E63 | Localized headings carry a stable canonical token; emit dates as `YYYY-MM` machine value plus optional localized display, never bare `DD/MM` or `MM/DD`; name in a privileged slot; country presets keep photo/DOB/nationality/marital-status off by default. Cross-reference issue #84. |

### Qualifications and Strengthening of Existing Rules (Pass 2)

- R02 and R11 are strengthened by direct reading-order parsing evidence (E44, E45): a correct linear reading order measurably improves machine extraction, and columnar/scrambled layouts are the documented failure mode. E34/E35/E37 add that relevance and readability, not volume, drive human evaluation.
- R03 (experienced candidates lead with experience) and R04 (early-career ordering) are reframed as relevance and scan-efficiency heuristics, not a primacy guarantee. Recruiter eye-tracking shows dwell-time does not predict the decision (E64, and the existing E09), and serial-position direction is task-dependent and often recency (E65). This supports the existing R03 REVISE flag.
- R06 and R14 are strengthened: contextual skills tied to concrete work outperform detached lists (E52 reports about +29.4% matching; E51, E53 concur).
- R13 is re-strengthened from weak/pragmatic to moderate: a compact global skills block has machine-matching value (E49), provided every skill also surfaces on concrete work per R06. "Skills near the end" softens to "skills remain within the high-scan upper region for technical roles," pending a real format experiment that the literature still lacks.
- R15 is enriched by current LLM job-resume bias evidence (E46): screener behavior is biased and shifting, so gaming a specific system is both unsound and unstable.
- Length and density: no rule. Peer-reviewed evidence ties better evaluation to role-relevant, readable, error-free, deterministic output (E34, E35, E36, E37), not to any fixed length or page count.

### Rejected Folklore (Pass 2 additions)

- The "recruiters spend 6 (or 7.4) seconds" figure has no peer-reviewed primary source; it traces to unpublished commercial white papers. The two genuine peer-reviewed recruiter eye-tracking studies (E09 Pina 2023, E64 Torngren 2024) both find dwell-time does not predict the decision.
- No peer-reviewed controlled experiment on reverse-chronological vs functional format was located; the "most recruiters prefer chronological" figure has no verifiable study behind it.
- Numeric quantification of bullets ("increased X by 40%") has no isolating peer-reviewed experiment; the renderer must not pressure users to add numbers.
- Structured machine-readable export formats (JSON Resume, schema.org, HR-Open) have no peer-reviewed evaluation found; any export rule rests on interoperability and engineering grounds plus the indirect "structured and ordered data extracts better" inference (E44, E45, E47, E49), not on a hiring-outcome citation.
