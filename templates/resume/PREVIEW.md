# Resume template — layout

A clean, single-column, one-page-friendly resume. Designed to pass Applicant
Tracking Systems (ATS): real selectable text, no multi-column layout, no images
or text boxes, standard fonts (Latin Modern), simple structure.

```
┌──────────────────────────────────────────────────────────┐
│ FIRSTNAME LASTNAME                        (large, slate)   │
│ Senior Software Engineer                  (tagline, muted) │
│ email | phone | city | linkedin | github  (small)         │
│ ──────────────────────────────────────────────────────    │
│                                                            │
│ SUMMARY                                    (section rule)  │
│ 1–3 lines tailored to the role.                            │
│                                                            │
│ EXPERIENCE                                                 │
│ Role, Company                              Dates (right)   │
│ Location (italic, muted)                                   │
│   • action + what + quantified impact                      │
│   • ...                                                    │
│                                                            │
│ SKILLS                                                     │
│ Languages: ...   Infra: ...   Data: ...                    │
│                                                            │
│ EDUCATION                                                  │
│ Degree                                     Dates (right)   │
│ Institution, Location (italic, muted)                      │
└──────────────────────────────────────────────────────────┘
```

## Files
- `resume.cls` — all styling (colors, fonts, spacing, the `\experience`,
  `\bullets`, `\skillline`, `\education`, `\resumeheader` commands). Edit here to
  restyle; you rarely need to.
- `resume.tex` — content only. The `tailor-resume` skill copies this into an
  application folder and replaces placeholders with tailored content.

## Customizing the look
- **Accent color:** change `\definecolor{accent}{HTML}{2B3A55}` in `resume.cls`.
- **Margins:** the `\geometry{margin=1.5cm}` line in `resume.cls`.
- **Font:** swap `\RequirePackage{lmodern}` for another (e.g. `helvet`).

## Compile
```
tectonic resume.tex      # needs resume.cls in the same directory
```

## ATS notes
- Keep it text-based — do not add logos, photos, or icon fonts.
- Section names are conventional (Summary / Experience / Skills / Education) so
  parsers recognize them.
- Escape LaTeX specials in content: `& % $ # _ { } ~ ^` and use `---` for em-dashes.
```
