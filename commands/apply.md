---
description: Hand-curate a tailored resume and cover letter (LaTeX -> PDF) for a job posting URL. Reads your private profile from the configured data dir and pauses for your review before final PDFs.
argument-hint: "<job-url>"
allowed-tools: Read, Write, Bash, WebFetch, Grep, Glob, Skill, Agent
---

Curate a full job application for this posting: **$ARGUMENTS**

If the argument is empty or is not a URL, ask the user for the job posting URL before continuing.

Then invoke the `curate-application` skill, passing it the URL. That skill orchestrates the whole
pipeline (ingest profile -> parse posting -> analyze fit -> tailor resume -> draft cover letter ->
**pause for your review** -> build PDFs) using the private data directory configured for this plugin
(`${user_config.data_dir}`) and the bundled LaTeX templates.

Follow the skill's human-in-the-loop pauses — do not produce final PDFs until the user approves the
drafts, and never fabricate experience the user does not have.
