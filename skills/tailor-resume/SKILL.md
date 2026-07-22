---
name: tailor-resume
description: Produce a tailored resume.tex for a specific job by selecting and rewriting content from the user's master resume against the posting analysis, filling the LaTeX template. Use after parse-job-posting and job-analyst have run. Never invents experience.
allowed-tools: Read, Write, Bash, Grep, Agent
---

Generate `APP_DIR/resume.tex` — a one-page (unless clearly warranted otherwise), ATS-friendly resume
tailored to this posting.

**Inputs** (paths provided by the caller):
- `${user_config.data_dir}/profile/master-resume.md` — the full canonical history.
- `${user_config.data_dir}/profile/personal.md` — contact info.
- `APP_DIR/job-posting.md` and `APP_DIR/analysis.md` — the target and the fit analysis.
- Template: `${CLAUDE_PLUGIN_ROOT}/templates/resume/` (`resume.tex` + `resume.cls`).

Read `bullet-writing.md` in this skill directory for the bullet/keyword rules before writing.

## Steps

1. **Read** the master resume, personal info, posting, and analysis.

2. **Select** the roles and bullets from the master resume that best match the must-haves and
   keywords. Prefer relevance over recency ordering only when relevance clearly wins; otherwise keep
   reverse-chronological. Aim for the most relevant material fitting one page.

3. **Rewrite** selected bullets per `bullet-writing.md`: strong action verb, concrete outcome,
   quantified impact, and the posting's keywords **only where truthfully supported**. Tighten the
   summary line to target this exact role.

4. **Delegate the heavy rewriting to the `resume-curator` agent** (Agent tool) when the master
   resume is large or the mapping is non-trivial: pass it the master resume, the analysis, and the
   bullet-writing rules; ask it to return the ranked, rewritten bullet set with a one-line rationale
   each. Otherwise do it inline.

5. **Fill the template.** Copy `${CLAUDE_PLUGIN_ROOT}/templates/resume/resume.cls` into `APP_DIR`
   (the class must sit beside the .tex), then write `APP_DIR/resume.tex` based on the template,
   substituting real content into `\resumeheader`, `\experience`, `\bullets`, `\skillline`,
   `\education`.
   - **Escape LaTeX specials** in all content: `& % $ # _ { } ~ ^` (e.g. `R\&D`, `30\%`, `C\#`,
     `file\_name`) and use `---` for em-dashes. This is the most common compile failure — check it.

6. **Report** to the caller: the summary line, the bullets you kept/rewrote, and anything relevant
   you deliberately left off (for the review pause). Do NOT compile here — build-pdf does that after
   the user approves.
