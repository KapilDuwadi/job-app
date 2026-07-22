---
name: parse-job-posting
description: Fetch a job posting URL and extract a clean, structured summary — role, company, must-have vs nice-to-have requirements, ATS keywords, seniority, and tone. Writes job-posting.md into the application folder. Use when starting to tailor an application to a specific posting.
argument-hint: "<job-url>"
allowed-tools: Read, Write, WebFetch
---

Turn a job posting URL into a clean, structured `job-posting.md` inside the current application
folder (`APP_DIR`, provided by the caller).

## Steps

1. **Fetch** the URL (in `$ARGUMENTS`) with WebFetch, asking it to return the full job description
   text: title, company, location/remote, responsibilities, requirements, and any "about us".

2. **If the fetch fails** (login wall, JS-only page, 403, or thin content): tell the user the page
   couldn't be read and ask them to paste the job description text. Proceed from what they paste.

3. **Extract and write `APP_DIR/job-posting.md`** with these sections:

```markdown
# <Job title> — <Company>

- URL: <source url>
- Location: <city / remote / hybrid>
- Seniority: <junior/mid/senior/staff/etc — inferred>
- Tone: <formal / casual / mission-driven — how the posting reads>

## What the role does
- Bullet summary of the responsibilities.

## Must-have requirements
- The hard requirements (years, degrees, specific tech, clearances).

## Nice-to-have
- Preferred / bonus qualifications.

## Keywords (for ATS)
- The exact terms and technologies the posting repeats — comma-separated. These are what the
  resume should mirror WHERE TRUTHFUL.

## Notes
- Anything notable: red flags, unusual asks, what they seem to value most.
```

4. Keep it faithful to the source — don't editorialize requirements into existence. Distinguishing
   must-have from nice-to-have is a judgment call; when unclear, put it under nice-to-have and note
   the ambiguity.
