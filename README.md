# job-app — hand-curated resumes & cover letters

A Claude Code plugin that turns a **job posting URL** into a tailored **resume** and **cover
letter**, compiled to good-looking PDFs with LaTeX. It reads your profile from a private data
directory kept **separate** from the plugin, and keeps you in the loop — it pauses for your review
before producing final PDFs and never fabricates experience.

## How it's organized

Two locations, deliberately separate:

- **The plugin** (this folder) — shareable logic: skills, agents, LaTeX templates, the `/apply`
  command. No private data.
- **Your data directory** (e.g. `~/.job-app`) — your profile and per-job output. You configure its
  path at install time; nothing private lives in the plugin.

```
this-plugin/
├── .claude-plugin/plugin.json     # manifest + the data_dir setting
├── commands/                      # /job-app:apply <url>, /job-app:hunt [count]
├── skills/                        # curate-application, ingest-profile, parse-job-posting,
│                                  #   tailor-resume, write-cover-letter, build-pdf,
│                                  #   find-companies, hunt-jobs
├── agents/                        # job-analyst, resume-curator
├── templates/                     # resume/ (resume.cls, resume.tex), cover-letter/
└── scripts/new-application-dir.sh
```

```
~/.job-app/                        # YOUR data dir (create this)
├── profile/
│   ├── personal.md                # name, contact, links, work authorization
│   ├── master-resume.md           # your FULL history — tailoring selects from it
│   ├── preferences.md             # hunt prefs: salary, remote, locations (default USA)
│   ├── company-targets.md         # hunt watch-list: verified ATS boards to search
│   ├── old-resume.pdf             # optional: parsed once into master-resume.md
│   └── writing-samples/           # optional: prior letters/emails for voice matching
└── applications/
    └── YYYY-MM-DD-company-role/    # one folder per job (created automatically)
        ├── job-posting.md
        ├── analysis.md
        ├── resume.tex → resume.pdf
        ├── cover-letter.tex → cover-letter.pdf
        └── notes.md
```

## Installation

This plugin ships through a Claude Code **plugin marketplace** hosted in this repo. Install it from
inside Claude Code:

1. **Add the marketplace** (points Claude Code at this repo):

   ```
   /plugin marketplace add KapilDuwadi/job-app
   ```

   You can also use the full URL — `/plugin marketplace add https://github.com/KapilDuwadi/job-app`
   — or a local path if you've cloned it — `/plugin marketplace add /path/to/job-app`.

2. **Install the plugin** from that marketplace:

   ```
   /plugin install job-app@job-app
   ```

   (The format is `<plugin>@<marketplace>`; both are named `job-app` here.) You can also browse and
   install interactively by running `/plugin` and selecting **job-app**.

3. **Set the `data_dir` config** when prompted — this is your private profile folder (e.g.
   `~/.job-app`), kept separate from the plugin so no private data ships with it. This is required
   before the first run.

4. **Verify** the install: run `/help` and confirm `/job-app:apply` appears in the command list.

> **Updating:** `/plugin marketplace update job-app` refreshes the marketplace, then re-run
> `/plugin install job-app@job-app`. **Uninstalling:** `/plugin uninstall job-app@job-app`.

## Setup

1. **Install Tectonic** (the LaTeX engine — self-contained, auto-fetches packages):
   - Windows: `winget install TectonicTypesetting.Tectonic`
   - Cargo:   `cargo install tectonic`
   - Scoop:   `scoop install tectonic`
   - macOS:   `brew install tectonic`
   - Verify: `tectonic --version`

2. **Populate your profile.** The first run bootstraps this for you:
   - If `~/.job-app/profile/` is empty, the `ingest-profile` step writes placeholder
     `personal.md` and `master-resume.md` and stops so you can fill them in.
   - Or drop an existing resume at `~/.job-app/profile/old-resume.pdf` — it gets parsed once into
     `master-resume.md` for you to verify.

## Use

```
/job-app:apply https://company.example.com/careers/senior-swe
```

The pipeline runs: **ensure profile → parse posting → analyze fit → tailor resume → draft cover
letter → PAUSE for your review → build PDFs**. You review and edit the drafts before anything is
finalized; results land in a dated folder under `~/.job-app/applications/`.

## Hunt for matching jobs

Don't have a posting yet? `/job-app:hunt` works the other direction — it discovers openings that fit
**you**, ranks them against your CV, and hands the best ones straight to `/job-app:apply`.

```
/job-app:hunt          # or: /job-app:hunt 5   (cap the result count)
```

It runs: **ensure preferences → ensure a company watch-list → ask how many / how far back → fetch
each company's openings → prefilter by your preferences → score against your CV → ranked list**.

- **First run** bootstraps two files in `profile/`:
  - `preferences.md` — salary floor, work mode (remote/hybrid/onsite), locations (**country defaults
    to USA**), seniority, and keywords to seek/avoid. It's written as a placeholder and the hunt
    **stops** until you fill it in.
  - `company-targets.md` — a watch-list. The `find-companies` step suggests ~20 companies from your
    skills and education, **you verify/edit the list**, then it auto-resolves each to a public ATS
    board and saves only the ones that resolve.
- Each result shows a match score, the role, location, posting date, and a direct apply URL. Pick any
  and run `/job-app:apply <url>` to deep-tailor a resume + cover letter.

**How it stays compliant:** the hunt reads only **public applicant-tracking boards** — Greenhouse,
Lever, and Ashby JSON endpoints — never LinkedIn or any login-walled/scraped page.

**Scope & limits:** results come only from companies on your watch-list (not a whole-market search),
and only from those three ATS platforms — large employers on Workday/Taleo/custom boards are flagged
`unresolved` for you to add a slug manually rather than guessed at. Re-run `find-companies` anytime to
widen the list.

## Customizing the look

- **Accent color / margins / font:** edit `templates/resume/resume.cls` (see
  `templates/resume/PREVIEW.md`). The resume content lives in `resume.tex`; styling is isolated in
  the class file.
- The resume is intentionally **ATS-friendly**: single column, real text, standard fonts, no
  images or icon fonts.

## Principles baked in

- **Honesty:** keywords are mirrored only where your real history supports them; gaps are surfaced
  in `analysis.md` and `notes.md`, not hidden.
- **Human-in-the-loop:** you approve drafts before PDFs are built.
- **Separation:** your data never lives in the plugin, so the plugin stays shareable.

## Requirements
- Claude Code with plugin support.
- Tectonic on PATH (for PDFs). Without it, `build-pdf` emits `.tex` you can compile on Overleaf.
- `pdftotext` is used as a fallback when parsing `old-resume.pdf` (optional).
