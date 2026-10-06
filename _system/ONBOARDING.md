# Brand onboarding

From "here is our website" to "first article delivered". Budget about an hour. After that, each
article is the normal pipeline in `CLAUDE.md`.

You can do every step below yourself, or open the repo in Claude Code and say
**"Onboard my brand: https://www.yoursite.com"** and it will walk through them with you.

Throughout, `<Brand>` is a short folder name for your brand, e.g. `Acme`.

---

## Step 0 — Write down the rules nobody can see on the website

Create `<Brand>/STYLE-RULES.md` from `_system/STYLE-RULES-template.md` **before** you scan
anything. Copy rules bind the images, not just the prose, and none of them are discoverable from a
website. Your own site may even still use a word you have since banned. The questions that matter:

- Banned words or phrasings (and preferred replacements).
- How the brand name is written (caps, spacing, legal suffix).
- May an image carry **product claims, case studies, ratings or pricing**, or is it editorial only?
  (Editorial only is the safe default: the brand appears just in the domain line.)
- How competitors may be named, if at all.
- Your published prices, so an illustrative number never collides with a real tier.

Getting this wrong means rewriting strings in finished images.

## Step 1 — Scan the site

```powershell
.\_system\brand-scan.ps1 -Url "https://www.yoursite.com/"
```

It reports Google Fonts imports, font families ranked by declaration count, and hex colours
ranked by use count (neutrals flagged so they don't drown the signal).

**Treat the colour ranking as a lead, not a verdict.** Frequency finds what the CSS *repeats*,
which is not the same as what the brand *is*. It is common for `#ffffff` to appear 50+ times while
the real primary appears once, because the primary arrives through gradients and utility classes.

Fonts are the opposite: the ranking is reliable. Ignore `system-ui`, `inherit`, icon fonts and the
generic fallbacks at the tail.

## Step 2 — Confirm the colours by eye

Pull the primary from where the brand actually asserts itself:

- the **primary CTA button** (the brand colour more often than not);
- the **logo**;
- link colour in body copy;
- any **gradient** used as a signature;
- the footer or nav background for the dark token.

Then look for a design-token block: search the CSS for `:root`, `--color`, `--brand`, `--primary`
or a `theme` block. If you find one, prefer it over the frequency scan.

**Theme defaults rank high and are not your brand.** WordPress/Divi ships `#2ea3f2` as a default
link blue; Webflow component libraries ship whole palettes. A colour that ranks high but is absent
from the CTA button, the logo and the headings belongs to the theme.

## Step 3 — Decide light or dark canvas

Look at the page the diagrams will sit on, which is usually the **blog body**, not the homepage.
A dark homepage often has a light blog body.

- Light: `Copy-Item _system\brand-template.css "<Brand>\brand.css"`
- Dark: `Copy-Item _system\brand-dark-example.css "<Brand>\brand.css"`

## Step 4 — Fill in the brand file

Fill in every token. The file is annotated with what each one is for. Rules that are not optional:

- **Keep the compatibility-alias block at the bottom.** An undefined CSS var in an SVG `stroke`
  fails silently: the path doesn't paint and only the arrowhead shows.
- **Only ever use tokens in an image.** No raw hex in a scene file.
- **Check the weights your webfont actually ships.** A missing weight rounds *away* from the body
  text, so a requested 800 becomes 900. If your site never uses 800, cap display weights at 700
  with a scoped `body .t-title{font-weight:700}` (see GOTCHAS.md, "Brand and tokens").
- **If your primary sits near a semantic colour** (red, orange, yellow, green), move `--bad` /
  `--warn` / `--ok` away from it, so a brand fill is never read as a verdict.
- **A display face may be headline-only.** If your site uses a decorative heading face only for
  big titles, keep `--font-head` as the UI face and set the title face with a scoped
  `body .t-title{font-family:...}`. `--font-head` also drives chips, pills, badges and the domain line.

## Step 5 — Prove the brand renders

```powershell
New-Item -ItemType Directory "<Brand>\_brandcheck" | Out-Null
Copy-Item _templates\T01-flow-linear.html "<Brand>\_brandcheck\01-check.html"
Copy-Item _templates\T10-vs-checklist.html "<Brand>\_brandcheck\02-check.html"
# in each file: first <link> -> ../brand.css, second -> ../../_system/base.css,
# and replace clientdomain.com with your domain
.\_system\render.ps1 -Path "<Brand>\_brandcheck" -Force
.\_system\review.ps1 -Path "<Brand>\_brandcheck"
```

Check three things: the webfonts actually loaded (not a fallback), the primary reads on the canvas,
and the `.site` domain is right. Pick one template with semantic marks (ticks/crosses) so you see
`--ok` / `--bad` against your brand. Delete `_brandcheck` once it passes.

## Step 6 — Seed the ledger

Create `<Brand>/USED-TEMPLATES.md` from `_system/LEDGER-template.md` and fill in:

- **domain** for `.site`;
- **domain vocabulary**: the nouns that make scenes feel real in your industry;
- **identifier ranges**: so two articles never show the same order/ticket number with different data;
- **positioning**: how the brand may be described.

## Step 7 — Pick the first article

1. Open your blog index and **filter out software listicles** ("Best/Top N … software").
2. Prefer guides and how-tos with **tables and lists spread out** rather than clustered; those have
   more legal image slots (see PLACEMENT-RULES.md).
3. Run **one article end to end** and review it before batching the rest. Fix design notes in the
   brand file or base.css, not in individual images.

---

## Onboarding gotchas

- **Self-hosted fonts.** If the scan finds `@font-face` and no Google Fonts import, your font is
  licensed and may not be importable. Options, in order: find it on Google Fonts under another name,
  pick the closest Google equivalent, or reference your own webfont files with an `@font-face`
  block in `brand.css`.
- **Webflow / Framer / Squarespace sites** put everything in one giant minified stylesheet. The scan
  handles this, but the token block is usually absent, so Step 2 matters more.
- **Sites behind Cloudflare** may refuse `Invoke-WebRequest`. If the scan returns nothing, open the
  page in a browser, copy the CSS from dev tools, and read it by hand.
- **A dark canvas is more than two tokens.** `brand-dark-example.css` carries the full tuning block:
  inverted surfaces, a card hairline instead of a shadow, dark text on a light brand fill, and
  repointed semantic tints. Watch for any token **darker than the canvas** (often the gradient's dark
  stop): a shape painted with it disappears.
