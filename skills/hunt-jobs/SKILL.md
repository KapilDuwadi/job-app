---
name: hunt-jobs
description: Fetch current openings from the user's company watch-list (public Greenhouse / Lever / Ashby boards), prefilter by their preferences, score the shortlist against their CV, and return a ranked list of the best-matching roles. Use when the user runs /job-app:hunt or asks to find jobs that fit them.
argument-hint: "[count]"
allowed-tools: Read, Write, Bash, WebFetch, Grep, Glob, Skill, Agent
---

Find and rank job openings that fit the user. This reads **public ATS boards only** — never
login-walled or scraped sites — and never fabricates experience. It is discovery; deep tailoring
stays in `/job-app:apply`.

**Profile dir:** `${user_config.data_dir}/profile/`.
Optional scope hint (e.g. a result count) is in `$ARGUMENTS`.

## Pipeline

1. **Ensure preferences.** Read `${user_config.data_dir}/profile/preferences.md`.
   - If it's missing or still contains `<<PLACEHOLDER>>`, write the placeholder below into that path
     and **STOP** — ask the user to fill in salary / work mode / locations / keywords and re-run.
   - When reading it, treat **country as USA by default** if the user left locations blank.

2. **Ensure a watch-list.** Read `${user_config.data_dir}/profile/company-targets.md`.
   - If it's missing, or has no rows with `status = verified`, invoke the `find-companies` skill to
     build one, then continue. (If `find-companies` stops for user input, relay that and stop.)

3. **Ask scope.** Ask the user two things (parse a count from `$ARGUMENTS` if present):
   - **How many results** do you want? (default 10)
   - **How far back** should postings be, in days? (default 30)

4. **Fetch openings.** For each `verified` company, WebFetch its `board-url` and flatten every posting
   into a candidate with: company, title, location, remote flag, posted date, department, and the
   **absolute apply URL**. Endpoint shapes:
   - Greenhouse `.../boards/<slug>/jobs` → `jobs[]` (`title`, `location.name`, `absolute_url`, `updated_at`).
   - Lever `.../postings/<slug>?mode=json` → array (`text`, `categories.location`, `hostedUrl`, `createdAt`).
   - Ashby `.../job-board/<slug>` → `jobs[]` (`title`, `location`, `jobUrl`, `publishedAt`, `isRemote`).
   If a board fails to fetch, note it and continue with the rest.

5. **Prefilter (mechanical — no scoring yet).** Drop candidates that clearly fail preferences:
   - location/country mismatch (default USA), work mode conflict (e.g. onsite-only when user wants
     remote), posted before the day window, or seniority/keyword mismatches vs. the seek/avoid lists.
   - **Report the counts:** how many fetched, how many dropped and why. Never silently truncate.

6. **Score the shortlist.** For each survivor, judge fit against `master-resume.md` + `preferences.md`
   and assign a **`0–100` match score** with a one-line honest verdict and 1–2 gap notes — same
   scoring idiom as the `job-analyst` agent, but done inline. **Do not** spawn the full `job-analyst`
   company-research agent per job; that depth is reserved for `/job-app:apply`.

7. **Rank & present.** Sort by score, cap to the requested count, and print a table:

   | # | score | company | role | location | posted | apply |
   |---|---|---|---|---|---|---|

   Under each row (or in a following list), give the one-line reason and any gap. If more roles
   qualified than the cap, say how many were left off.

8. **Handoff.** Tell the user they can run `/job-app:apply <apply-url>` on any row to deep-tailor a
   resume and cover letter. Optionally save the run to
   `${user_config.data_dir}/applications/hunts/` (create the dir if needed) as a dated record.

## Placeholder: `preferences.md`

```markdown
# Job preferences  <<PLACEHOLDER — fill in, then delete this marker>>

- Salary floor (USD/yr):
- Work mode (remote / hybrid / onsite / any):
- Locations (City, ST; country defaults to USA if blank):
- Seniority (e.g. senior, staff):
- Titles / roles to seek:
- Keywords to seek:
- Keywords / industries to avoid:
- Company size preference (optional):
```

## Notes
- **Honesty:** scores reflect the real CV. Surface gaps in the reason line rather than inflating fit.
- **Scope:** results are limited to companies on the watch-list and to the three supported ATS
  platforms — this is not a whole-market search. Run `find-companies` to widen the list.
- Keep the user informed at each step; surface how many postings were fetched vs. filtered.
