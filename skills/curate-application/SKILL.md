---
name: curate-application
description: Orchestrate end-to-end hand-curation of a tailored resume and cover letter for a job posting URL. Use when the user runs /job-app:apply or asks to build application materials for a specific job. Runs the full pipeline and pauses for human review before producing final PDFs.
argument-hint: "<job-url>"
allowed-tools: Read, Write, Bash, WebFetch, Grep, Glob, Skill, Agent
---

You are curating a job application. This is **hand-curation with a human in the loop** — not
fire-and-forget. You pause for the user's review before committing to final PDFs, and you never
invent experience the user does not have.

**Data directory:** `${user_config.data_dir}` (their private profile + output; e.g. `~/.job-app`).
**Plugin templates:** `${CLAUDE_PLUGIN_ROOT}/templates/`.

The job URL is in `$ARGUMENTS`. If it's empty or not a URL, ask the user for it before proceeding.

## Pipeline

Run these in order. Each step is a separate skill or agent; invoke them via the Skill/Agent tools.

1. **Ensure the profile is ready** — invoke the `ingest-profile` skill.
   - If it reports the profile is missing/placeholder, STOP and relay its instructions to the
     user. Do not continue with a fabricated profile.

2. **Create the application folder** — run:
   ```
   bash "${CLAUDE_PLUGIN_ROOT}/scripts/new-application-dir.sh" "${user_config.data_dir}" "<company>" "<role>"
   ```
   You may not know company/role yet — if so, do step 3 first, then create the folder. The script
   prints the created path; use it as `APP_DIR` for everything below.

3. **Parse the posting** — invoke `parse-job-posting` with the URL. It writes `APP_DIR/job-posting.md`.
   - If the fetch fails or the posting is login-walled, it will ask the user to paste the text.

4. **Analyze fit** — spawn the `job-analyst` agent (Agent tool) with the posting and profile paths.
   It writes `APP_DIR/analysis.md` (fit, gaps, keywords, talking points). Relay its summary.

5. **Tailor the resume** — invoke `tailor-resume`. It uses the `resume-curator` agent and writes
   `APP_DIR/resume.tex` from the template + master resume + analysis.

6. **Draft the cover letter** — invoke `write-cover-letter`. It writes `APP_DIR/cover-letter.tex`.

7. **PAUSE FOR REVIEW.** Show the user:
   - the tailored resume bullets and summary (the meaningful content, not raw LaTeX),
   - the cover letter draft in full,
   - a short note of what you emphasized and what you left out, and why.
   Ask for edits. Incorporate any changes into the `.tex` files. Do **not** proceed to PDF until
   the user is happy.

8. **Build PDFs** — invoke `build-pdf` on both `.tex` files in `APP_DIR`.

9. **Write `APP_DIR/notes.md`** — record what was emphasized/omitted and why, the target keywords
   used, and any gaps the user should be ready to address in an interview.

## Principles
- **Honesty:** mirror the posting's language only where it's truthfully supported by the master
  resume. Never manufacture titles, dates, metrics, or skills. If a must-have is missing, say so
  in `analysis.md` and `notes.md` rather than papering over it.
- **Specificity:** every claim ties to a real accomplishment. Cut generic filler.
- **One page** for the resume unless the user's history clearly warrants two.
- Keep the user informed at each step; surface tradeoffs rather than deciding silently.
