# In-article diagram images

Simple explainer diagrams that go **inside** a blog post, plus a markdown file telling the editor
exactly where each one goes. This file is the operating manual for Claude Code. Humans start with
`README.md`.

## What a delivery is

Per article: **up to 5 images** (`.png` at 2× + editable `.html`) and one **`PLACEMENT.md`**.
Each image is one idea, readable in about two seconds, in the brand's colours and fonts, with the
brand's domain in the bottom-right corner.

## Layout

```
_system/
  base.css                # brand-agnostic structure + all diagram primitives + the type scale
  brand-neutral.css       # placeholder brand - template gallery ONLY, never a deliverable
  brand-template.css      # annotated blank brand file (light canvas) - copy when onboarding
  brand-dark-example.css  # worked dark-canvas brand file - copy instead if the brand is dark
  ONBOARDING.md           # website URL -> brand.css -> first delivered article
  TEMPLATE-LIBRARY.md     # the 39 templates: what each answers + house style
  PLACEMENT-RULES.md      # the placement contract + PLACEMENT.md format
  GOTCHAS.md              # paid-for lessons - READ BEFORE AUTHORING
  LEDGER-template.md      # starting point for <Brand>/USED-TEMPLATES.md
  STYLE-RULES-template.md # starting point for <Brand>/STYLE-RULES.md
  render.ps1              # HTML -> PNG, reads the ratio off the <body> class
  review.ps1              # builds + renders a one-page contact sheet for an article folder
  brand-scan.ps1          # pulls fonts + colours off a live site
  find-browser.ps1        # locates Edge/Chrome (used by render + review)
_templates/
  T01..T39-<name>.html    # reusable skeletons with neutral placeholder copy (+ .png previews)
  _gallery.html/.png      # contact sheet of all templates
<Brand>/                  # created during onboarding - one folder per brand
  brand.css               # the brand's tokens + fonts + compatibility aliases
  STYLE-RULES.md          # copy rules, banned words, proof policy - binds the images
  USED-TEMPLATES.md       # ledger: template per image, idea ownership, vocabulary, ID ranges
  <article-slug>/
    source.md             # optional: the article text, if it is not live yet
    01..05-<scene>.html + .png
    _review.html/.png     # QA contact sheet (generated, not a deliverable)
    PLACEMENT.md
```

Article HTML links `../brand.css` then `../../_system/base.css`, **in that order**.

## First run: is there a brand yet?

If no `<Brand>/brand.css` exists, the user has not onboarded. Walk them through
`_system/ONBOARDING.md` before anything else. Ask for, at minimum:

1. the website URL (for the brand scan and the `.site` domain);
2. any **copy rules**: banned words, how competitors may be named, whether product claims,
   pricing, case studies or ratings may appear on images; spelling of the brand name;
3. whether the diagrams sit on a **light or dark** page.

Write the answers into `<Brand>/STYLE-RULES.md`. Copy rules are not discoverable from a website,
so ask rather than guess.

## Ratios: 16:9 and 1:1 only

No portrait images. Ratio follows the *idea*: sequences and comparisons go 16:9; loops, radial
shapes, single objects, single numbers and vertical stacks go 1:1.

## Workflow for a new article

1. **Read the source.** Either the live URL (preferred: placement quotes must match the live page)
   or `<Brand>/<slug>/source.md` if the article is not published yet. Never edit the source.
2. **Map the legal slots first.** Walk every section's block sequence and mark where an image can
   legally go per `_system/PLACEMENT-RULES.md`: only between two body paragraphs, never touching a
   table, list, heading or CTA, never at a section end. Expect about half the sections to have no
   legal slot. That is normal and gets recorded in PLACEMENT.md rather than worked around.
3. **Pick up to 5 ideas by what each paragraph ARGUES**, not what it is about. Write the H2 next to
   each and confirm all five are in different H2s and each has a legal slot. Check
   `<Brand>/USED-TEMPLATES.md` for ideas already drawn by another article (near-twin articles:
   decide which one owns which idea).
4. **Read `_system/GOTCHAS.md`**, then **budget the stage height** for each idea before writing
   (about 1056 × 410 usable on 16:9 under a two-line title; about 856 × 720 on 1:1).
5. **Author.** Copy each template in, swap the two stylesheet links, rewrite every string with the
   article's real facts, set the `.site` domain, add a `.credit` wherever a figure has a source.
   Grep every string against `<Brand>/STYLE-RULES.md`.
6. **Render:** `_system/render.ps1 -Path "<Brand>/<slug>" -Force` (always `-Force` after an edit;
   without it existing PNGs are skipped and you review stale images).
7. **QA by montage:** `_system/review.ps1 -Path "<Brand>/<slug>"`. Read ONE contact sheet, not five
   PNGs. Check every cell's bottom edge for overflow into `.site` / `.credit`. Fix, re-render,
   re-review. Then run the class-collision audit in GOTCHAS.md.
8. **Write `PLACEMENT.md`.** Before/after sentences must be copy-pasteable search strings from the
   live page. If the article is not live yet, say so in a banner at the top and tell the user to
   re-verify once it is published. Re-read the source as the **last** step: drafts change.
9. **Update the ledger** (`<Brand>/USED-TEMPLATES.md`). Promote a genuinely new shape to
   `_templates/` + `TEMPLATE-LIBRARY.md` + the gallery only if it answers a question no existing
   template does.

**Batching.** Run one article end to end and get it approved before starting a batch. Design notes
arrive early and are far cheaper to apply to the system than to 40 finished images. When a note
does arrive, fix it in `base.css`, the brand file or the template, not just in the one image.

## House rules

- **No software listicles.** "Best/Top N … software" round-ups are out of scope. Build for guides,
  how-tos and explainers.
- **16:9 and 1:1 only.**
- **No text on or above connector lines.** Labels go in a solid pill clear of the line, or onto the
  endpoint the line points at.
- **Arrows point at the centre of the shape they hit**, and stop on its edge.
- **Three type sizes and three text colours per image, maximum** (`--fs-xl` / `--fs-md` /
  `--fs-sm`). Hierarchy from weight and colour, not extra sizes.
- **Text inside cards is vertically centred**, and rows across sibling cards line up.
- **Every cell in a labelled sequence is labelled.** No abstract shape standing in for a word.
- **Attribution uses `.credit`**, never a hand-rolled `left:0`.
- **Brand tokens only.** No raw hex in an article file.
- **Real numbers or none.** Every figure comes from the article and its source is named on the
  image. Draw only what the prose asserts.
- **Never silently correct the article inside an image.** If the article's arithmetic disagrees with
  its prose, draw the checkable version and flag the discrepancy at the top of `PLACEMENT.md`.
- **The brand's copy rules bind the images, not just the prose.** Grep every finished `.html`
  against `<Brand>/STYLE-RULES.md` (including the brand's own published prices) before delivering.
- **Competitors stay generic** unless the article names them and treats them fairly.

## Rendering

Headless Edge or Chrome, `--headless=new`, 2× device scale, ratio-matched `--window-size`.
`render.ps1` already handles the things that silently break it (see the script header). Requires
PowerShell: Windows PowerShell 5.1 or PowerShell 7 (`pwsh`) on macOS/Linux.

## Editing files safely

- Use the Edit/Write tools for HTML. Never round-trip through PowerShell 5.1 `Get-Content -Raw` →
  `Set-Content`: it corrupts `→ · — ✓` characters.
- Keep every `.ps1` pure ASCII.
- Don't pipe text containing backticks through `python -c "..."` or unquoted heredocs in Bash.
