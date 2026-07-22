---
name: ingest-profile
description: Ensure the user's private profile is ready for tailoring — verify personal.md and master-resume.md exist in the data dir, parse an old-resume.pdf into master-resume.md on first run, or write placeholder templates and stop for the user to fill in. Use at the start of curating any application.
allowed-tools: Read, Write, Bash, Glob
---

Guarantee that the user's profile in `${user_config.data_dir}/profile/` is ready to tailor from.
This runs before any resume/cover-letter work. **Never fabricate a work history.**

## Steps

1. **Check what exists** in `${user_config.data_dir}/profile/`:
   - `personal.md`, `master-resume.md`, and optionally `old-resume.pdf`.
   - Use Glob / Read. Treat a file that still contains the `<<PLACEHOLDER>>` marker as "not filled in".

2. **If `master-resume.md` is missing but `old-resume.pdf` exists** — parse it once:
   - Try the Read tool on the PDF directly.
   - If that yields poor text, fall back to: `pdftotext -layout "<pdf>" -` (pdftotext is available).
   - Draft `master-resume.md` as a structured, COMPLETE canonical history (every role, dates,
     bullets, skills, education) — this is a superset any single resume draws from.
   - Then STOP and ask the user to review it for accuracy. Do not proceed to tailoring on an
     unverified auto-parse.

3. **If `personal.md` or `master-resume.md` is missing entirely (no PDF to parse)** — write the
   placeholder templates below into the profile dir, then STOP and tell the user to fill them in
   and re-run. Do not invent content.

4. **If both exist and are filled in** — read them, confirm they look complete, and report the
   profile is ready. Note anything obviously missing (e.g. no contact email) for the caller.

## Placeholder: `personal.md`

```markdown
# Personal info  <<PLACEHOLDER — replace all fields, then delete this marker>>

- Full name:
- Email:
- Phone:
- Location (City, ST):
- LinkedIn:
- GitHub / portfolio:
- Work authorization (e.g. citizen, needs sponsorship):
- Target roles / titles:
- Relocation / remote preferences:
```

## Placeholder: `master-resume.md`

```markdown
# Master resume  <<PLACEHOLDER — this is your FULL history; tailoring selects from it>>

## Summary
A few sentences on who you are professionally (edited per-application later).

## Experience
### <Role> — <Company> (<City/Remote>) — <Start>–<End>
- Accomplishment: action + what you did + quantified impact.
- Another accomplishment. Include metrics (%, $, time, scale) wherever real.
- List MORE than any single resume needs — tailoring picks the most relevant.

### <Previous role> — <Company> — <dates>
- ...

## Skills
- Languages / frameworks / tools / domains, grouped.

## Education
### <Degree> — <Institution> — <year>

## Projects / Open source (optional)
### <Project> — <link>
- What it does, your role, impact.

## Certifications / Awards (optional)
```

Also ensure `${user_config.data_dir}/profile/writing-samples/` exists (create empty if not) so the
cover-letter step can pick up voice samples the user may drop there later.
