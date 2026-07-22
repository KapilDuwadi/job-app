---
name: build-pdf
description: Compile resume.tex and cover-letter.tex to PDF with Tectonic, surfacing LaTeX errors with the offending lines and retrying after fixes. Falls back to emitting .tex only if Tectonic is unavailable. Use after the user has approved the drafts.
allowed-tools: Read, Write, Bash, Edit
---

Compile the approved `.tex` files in `APP_DIR` to PDF.

## Steps

1. **Preflight the engine:**
   ```
   tectonic --version
   ```
   - If it fails (not installed / not on PATH), tell the user and give install options, then STOP
     after confirming the `.tex` files are in place (they can compile on Overleaf or after install):
     - Windows: `winget install TectonicTypesetting.Tectonic`
     - Cargo:   `cargo install tectonic`
     - Scoop:   `scoop install tectonic`

2. **Compile each file** from inside `APP_DIR` (so `resume.cls` is found beside `resume.tex`):
   ```
   cd "APP_DIR" && tectonic resume.tex && tectonic cover-letter.tex
   ```
   Redirect output to a log if helpful. Tectonic auto-downloads any missing packages on first use.

3. **On a LaTeX error** (non-zero exit, no PDF written):
   - Read the error output; find the `file.tex:LINE` reference and the message.
   - The most common cause is an **unescaped special character** (`& % $ # _ { } ~ ^`) or a raw
     Unicode em-dash `—` (use `---`). Fix it in the `.tex` with Edit, then recompile.
   - Repeat until both PDFs are produced. Don't give up after one failure — read the actual error.

4. **Report** the final PDF paths and sizes. If you had to fix escaping, note what you changed so
   the pattern doesn't recur.

## Notes
- Tectonic writes `<name>.pdf` beside the source. There are no `.aux`/`.log` leftovers to clean.
- Keep both source and PDF in `APP_DIR` — the source is the record of what was sent.
