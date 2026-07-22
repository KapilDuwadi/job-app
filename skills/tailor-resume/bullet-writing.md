# Bullet-writing & ATS keyword rules

## The bullet formula
Every experience bullet should read as: **action verb + what you did + quantified impact**.

- **Strong verb first:** Led, Built, Shipped, Cut, Scaled, Automated, Designed, Migrated, Owned.
  Avoid weak openers: "Responsible for", "Worked on", "Helped with", "Assisted".
- **Concrete object:** what specifically — a system, a migration, a feature, a team.
- **Quantified outcome:** %, $, time saved, latency, throughput, users, scale, revenue. If you
  don't have a number, use a concrete result ("eliminated the nightly on-call page").

Good: *Cut checkout p95 latency 40% by rewriting the pricing service in Go, saving ~$120k/yr in
compute.*
Weak: *Responsible for improving performance of the checkout system.*

## STAR, compressed
Situation/Task are usually implicit; lead with the **Action** and end with the **Result**. One
line each. Don't narrate context the reader can infer.

## Keyword mirroring (ATS) — honestly
Applicant Tracking Systems and human screeners look for the posting's exact terms.
- Pull the exact technologies/skills from `job-posting.md` → Keywords, and use the **same wording**
  where the master resume truthfully supports it (e.g. posting says "Kubernetes" — don't leave it as
  "k8s" if you have the experience).
- **Never** add a keyword you can't back up. A skill listed but not demonstrable is a liability in
  the interview and dishonest. If a must-have keyword isn't supported, leave it out and flag the gap.
- Don't keyword-stuff. Mirroring means natural use in real bullets and the Skills section, not a
  hidden keyword dump.

## Selection & ordering
- Prioritize bullets that hit the posting's **must-haves** first.
- Keep reverse-chronological order for roles; within a role, put the most relevant bullet first.
- Drop or compress older/irrelevant roles to keep it to one page.
- 3–5 bullets for recent/relevant roles; 1–2 for older ones.

## Tone & mechanics
- Past tense for past roles; present tense for the current one.
- No first-person pronouns, no periods-optional inconsistency (pick one; the template omits them).
- Numbers as numerals ("5", not "five") for scannability.
- **Escape LaTeX specials** in every value: `& % $ # _ { } ~ ^`, and `---` for em-dashes.
