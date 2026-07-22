---
name: write-cover-letter
description: Draft a tailored cover letter in the user's voice for a specific job, filling the LaTeX template. Uses writing samples if present for voice matching. Use after the posting is parsed and the resume is tailored. Specific to the company and role, no clichés.
allowed-tools: Read, Write, Bash, Glob
---

Draft `APP_DIR/cover-letter.tex` — a focused, specific cover letter in the user's voice.

**Inputs:**
- `${user_config.data_dir}/profile/personal.md` and `master-resume.md`.
- `${user_config.data_dir}/profile/writing-samples/` — optional prior letters/emails for voice.
- `APP_DIR/job-posting.md` and `APP_DIR/analysis.md`.
- Template: `${CLAUDE_PLUGIN_ROOT}/templates/cover-letter/cover-letter.tex` (self-contained).

Read `voice-and-structure.md` in this skill directory before writing.

## Steps

1. **Read** the inputs. If `writing-samples/` has content, study the user's tone, sentence length,
   and vocabulary so the letter sounds like them — not like a generic template.

2. **Draft** 3–4 short paragraphs following `voice-and-structure.md`:
   - Hook naming the role + a specific, genuine reason for THIS company.
   - Evidence: the 1–2 strongest accomplishments mapped to their top needs (from `analysis.md`).
   - Fit: your trajectory ↔ where the team is going; early contribution.
   - Warm, brief close.

3. **Fill the template.** Write `APP_DIR/cover-letter.tex` from the template, replacing the
   letterhead (name/contact from `personal.md`), date, addressee (company; "Hiring Manager" if no
   name), and body.
   - **Escape LaTeX specials** (`& % $ # _ { } ~ ^`, `---` for em-dashes).
   - If the hiring manager's name isn't known, use "Dear Hiring Manager,".

4. **Report** the full draft text to the caller for the review pause. Do NOT compile — build-pdf
   does that after approval.

## Guardrails
- Specific, not generic: no "I am excited to apply for this opportunity" filler.
- Honest: every claim traces to the master resume.
- Concise: fits comfortably on one page. Fewer, stronger sentences beat length.
