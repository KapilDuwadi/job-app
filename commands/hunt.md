---
description: Discover matching job openings — suggest a company watch-list from your CV, fetch current postings from their public ATS boards, and rank them against your resume and preferences. Reads your private profile from the configured data dir.
argument-hint: "[count]"
allowed-tools: Read, Write, Bash, WebFetch, WebSearch, Grep, Glob, Skill, Agent
---

Hunt for job openings that fit the user. Optional scope hint in: **$ARGUMENTS** (e.g. a result count).

Invoke the `hunt-jobs` skill. It orchestrates the whole discovery pipeline using the private data
directory configured for this plugin (`${user_config.data_dir}`):

1. ensure job preferences exist (salary, remote, locations — default country USA),
2. ensure a verified company watch-list exists (building one via `find-companies` if not),
3. ask how many results and how far back to look,
4. fetch current openings from each company's **public ATS board** (Greenhouse / Lever / Ashby),
5. prefilter by preferences, score the shortlist against the CV, and print a ranked list.

This is discovery only — it never fabricates experience and never scrapes login-walled sites. Remind
the user they can run `/job-app:apply <url>` on any result to deep-tailor a resume and cover letter.
