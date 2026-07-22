---
name: find-companies
description: Suggest ~20 companies that fit the user's CV (skills, domains, seniority, education), let the user verify the list, then resolve each to a public ATS board (Greenhouse / Lever / Ashby) and write a verified watch-list to company-targets.md. Use before hunting for openings, or to refresh the watch-list.
allowed-tools: Read, Write, WebFetch, WebSearch, Bash, Glob
---

Build a **verified company watch-list** from the user's background. The list feeds `hunt-jobs`, which
fetches openings from each company's public ATS board. **Suggest from evidence in the CV; never
guess-fill a slug** — an unverified slug produces broken fetches later.

**Profile dir:** `${user_config.data_dir}/profile/`. **Watch-list:** `${user_config.data_dir}/profile/company-targets.md`.

## Steps

1. **Read the CV.** Load `${user_config.data_dir}/profile/master-resume.md` and `personal.md`.
   - If either is missing or still contains `<<PLACEHOLDER>>`, **STOP** and tell the user to run the
     profile setup (`ingest-profile`, e.g. via `/job-app:apply`) and fill in their history first. Do
     not invent a background to suggest from.

2. **Derive the target profile.** From the CV, extract: core skills / stack, domains / industries,
   seniority level, and education. Summarize this in one or two lines so the user sees what you're
   matching against.

3. **Propose ~20 companies** likely to hire this profile. Bias toward employers **known to use
   Greenhouse, Lever, or Ashby** (these expose the public boards this plugin reads). Use WebSearch if
   helpful to confirm a company hires for the user's stack/domain. For each, note your best guess of
   which ATS they use and a candidate slug.

4. **PAUSE FOR REVIEW.** Show the proposed list (company + guessed ATS). Ask the user to add, remove,
   or replace entries. Do not probe endpoints until the user confirms the list.

5. **Resolve slugs** for the confirmed list by probing the public endpoints with WebFetch. Derive slug
   candidates from the company name (lowercase, no spaces/punctuation; also try common variants). A
   response containing a jobs/postings array means the slug is verified:
   - Greenhouse: `https://boards-api.greenhouse.io/v1/boards/<slug>/jobs`
   - Lever: `https://api.lever.co/v0/postings/<slug>?mode=json`
   - Ashby: `https://api.ashbyhq.com/posting-api/job-board/<slug>`
   Try each ATS until one resolves. Stop probing a company once verified.

6. **Write `company-targets.md`** in the format below. Mark any company you could not resolve as
   `unresolved`. Then, if there are unresolved rows, **ask the user** to paste that company's careers
   URL or correct slug so it can be fixed — do not fabricate a slug to make a row look complete.

## Format: `company-targets.md`

```markdown
# Company watch-list  (verified public ATS boards — feeds /job-app:hunt)

| company | ats | slug | board-url | status |
|---|---|---|---|---|
| Acme | greenhouse | acme | https://boards-api.greenhouse.io/v1/boards/acme/jobs | verified |
| Globex | lever | globex | https://api.lever.co/v0/postings/globex?mode=json | verified |
| Initech | ashby | initech | https://api.ashbyhq.com/posting-api/job-board/initech | verified |
| Umbrella | ? | ? | ? | unresolved |
```

## Notes
- **Only these three ATS platforms** are supported (clean public JSON). Big employers on
  Workday / Taleo / custom boards won't resolve — flag them `unresolved` rather than forcing a slug.
- This is **discovery scoped to companies on the list** — it does not search the whole market. That's
  the deliberate tradeoff for staying compliant (no LinkedIn/HTML scraping).
- Re-run this skill anytime to refresh or extend the watch-list.
