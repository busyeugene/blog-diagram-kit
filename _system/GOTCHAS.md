# Gotchas already paid for

Every item here cost at least one rebuilt image. Most of them render **with no error and nothing
obviously broken at thumbnail size**, which is why they ship. Read this before authoring; skim it
again before delivering.

Contents: [Before you author](#before-you-author) · [Brand and tokens](#brand-and-tokens) ·
[Layout and overflow](#layout-and-overflow) · [Class collisions](#class-collisions) ·
[Flex and inline text](#flex-and-inline-text) · [SVG, connectors and geometry](#svg-connectors-and-geometry) ·
[Colour on the canvas](#colour-on-the-canvas) · [Charts and numbers](#charts-and-numbers) ·
[Copy and sourcing](#copy-and-sourcing) · [Tooling](#tooling) · [Pre-delivery checklist](#pre-delivery-checklist)

---

## Before you author

- **Map slot legality BEFORE picking ideas.** A section can be the perfect home for an idea and
  still have no legal slot. The shape that kills it is *paragraph → table → paragraph → CTA*, which
  is extremely common. A slot is legal only between two body paragraphs, and never directly against
  a paragraph carrying the CTA. Map every section's block sequence first, then pick ideas against
  slots that exist.
- **Check section uniqueness BEFORE authoring.** One image per H2. Write the H2 next to each of the
  five ideas and confirm they are all different, or one finished image gets thrown away.
- **BUDGET THE STAGE HEIGHT BEFORE AUTHORING.** This is the single most frequent failure. The
  symptom never varies: a note box, footer band or table's last row prints straight through the
  `.credit` line. Usable box: about **1056 × 410 on 16:9 under a two-line `.t-title sm`** (about 455
  tall under a one-line title) and about **856 × 720 on 1:1**. Six 54px rows plus a note is the
  whole 16:9 budget. Cap table cells at one line. An absolutely-positioned caption hanging below its
  parent is the usual extra 40px that tips it over.
- **`.t-title.sm` does nothing on a 1:1 canvas.** `body.r11 .t-title{font-size:42px}` out-specifies
  `.t-title.sm`, so a 1:1 title is always 42px and must fit 856px on one line (about 40
  characters), or it wraps and opens a gap above the content. Budget it when you write the title.
- **On 1:1 canvases, centre the content; don't pin it to the top.** `justify-content:flex-start` +
  a top margin over-corrects into a top-heavy image with dead space at the bottom.

## Brand and tokens

- **A brand file can only set tokens — it cannot override base.css rules**, because it loads first
  and loses at equal specificity. For a genuine structural tweak, scope it one level deeper:
  `body .t-title{font-weight:700}` wins regardless of load order.
- **Never put a brand token in a bare `:root{}` in base.css.** Its fallback block is
  `:where(:root)` (zero specificity) on purpose. If your colours don't show up, check this first.
- **Check the weights a webfont actually ships.** A missing weight rounds *away* from the body
  text: a requested 800 becomes 900, not 700, and headlines come out heavier than your site.
- **An undefined CSS var in an SVG `stroke` fails silently.** The path doesn't paint; only the
  marker shows. This is why every brand file carries the compatibility-alias block. Never delete it.
- **A light canvas is an assumption, not a default.** Confirm light vs dark on ONE render before
  authoring five. Dark needs the full tuning block in `brand-dark-example.css`.
- **A heading face may be headline-only.** `--font-head` drives `.lab`, `.pill`, `.num`, `.site`
  and `.bar-lab` too. A display serif wired there puts a fat slab on every 15px chip. Keep
  `--font-head` as the UI face and scope the display face to `body .t-title`.
- **When the brand primary sits near a semantic colour, move the semantic colour.** A red brand
  can't also be `--bad`; an orange or yellow brand neighbours `--warn`. Never put a brand-red hero
  fill and a red cross in the same image. On good/bad images, let `--ok/--warn/--bad` carry the
  verdict and keep `--brand` out.
- **White text on a mid-tone brand fill may be low contrast** (under 3:1). If it is the site's own
  button pattern, keep it, but keep anything written on it **bold** and at `--fs-md` or larger.

## Layout and overflow

- **Content that overflows the stage collides with `.site` and `.credit`, silently.** They are
  absolutely positioned against the stage's padding box. Check the bottom corners of every montage cell.
- **A fixed title height must fit the LONGEST sibling, not the typical one.** A 52px slot with one
  three-line title in the row silently overlaps the description beneath it, and it looks like a
  font problem rather than a layout one.
- **A percentage width inside an `align-items:center` flex column has nothing to resolve against.**
  `width:100%` collapses and the block renders as nothing. Give the inner block a real width.
- **A percentage bar needs a parent with real height.** With `align-items:end` the column shrinks
  to content and `height:24%` resolves against nothing; the bars vanish. Give the column `height:100%`.
- **A grid nested in a flex wrapper inside `.fill` takes its max-content width** and can run a
  column clean off the canvas sideways. `flex:1;min-width:0` does not reliably fix it. Make it ONE
  grid: axis labels and cells in the same `grid-template-columns:<axis>px minmax(0,1fr) minmax(0,1fr)`,
  every item with an explicit `grid-column` and `grid-row`.
- **A `grid-column` span with no explicit `grid-row` swallows the items after it.** Auto-placement
  fills the cells beside a span first. Give every item in a spanned grid an explicit row.
- **`1fr` keeps its own max-content as a minimum.** Two rows with the same template but different
  copy lengths stop lining up. Use `minmax(0,1fr)` for any column that must match its twin.
- **Flex gaps steal width from percentage children.** Eight 12.5% segments in a `gap:3px` row
  overflow by the seven gaps. Use `calc(X% - <gap × (n-1) / n>px)`.
- **`.fgrid` has `column-gap:30px`.** A template that uses arrow columns as its spacing must set
  `column-gap:0`, or the last item falls off the canvas.
- **Never set `top` on both a wrapper and its absolutely-positioned children.** The offset applies
  twice. Give the wrapper `top:0;height:100%` and let the children carry the position.
- **An absolutely-positioned label shrinks to the room left in its container** and wraps onto
  whatever sits below. Give every absolute pill or label `white-space:nowrap`.
- **An absolute axis label at 0% or 100% with `translateX(-50%)` puts half of itself off-canvas.**
  Centre interior ticks; use `transform:none` at the low end and `translateX(-100%)` at the high end.
- **A baseline inside one column only draws under that column.** A floor line or axis spanning a
  multi-column plot must be a sibling of the columns, not a child of the first one.
- **Prefer self-aligning highlights.** Style the row itself (`outline`, `background`) rather than
  positioning a separate box over it; a positioned highlight drifts when padding changes.
- `flex-direction:row-reverse` **inverts** `justify-content`: `flex-start` packs right.
- `transform:rotate(-90deg)` spins about the element centre: a rotated label's visual x is
  `left + width/2`.
- A `<span>` used as a bar fill needs `display:block`, or its `width` is ignored.

## Class collisions

- **Never use a base.css class name as your own class or modifier.** A modifier that reads as an
  adjective is the trap: `class="x-row win"` meaning "the winning row" inherits base.css's `.win`
  browser-window frame (640px fixed width, own background and shadow). One render produced a **93%
  bar shorter than a 60% bar**, a chart stating the opposite of its own data, with no error. Words
  that bite: `row node site lab tile bar-fill mark win item list pill band layer doc panel grid num
  cap arw unit sep hl chips cols bars tiles bands`.
- **Audit the class attributes, not a remembered list, even after the montage looks fine:**

  ```bash
  grep -oE '\.[a-zA-Z][a-zA-Z0-9_-]*' _system/base.css | sed 's/^\.//' | sort -u > /tmp/base-classes
  grep -ohE 'class="[^"]*"' <Brand>/<slug>/*.html | sed 's/class="//;s/"//' | tr ' ' '\n' | sort -u \
    | comm -12 - /tmp/base-classes
  ```

  Expect intended hits (`stage`, `fill`, `col`, `site`, `credit`, `t-title`, `arw`, `num`, `mark`).
  The ones to fix are your own modifiers.
- **A bare ELEMENT selector in a per-file `<style>` can break a base.css component.** `.x-r span{display:block}`
  also matches base.css's `.num` badge at the same specificity and wins (it loads last). Scope text
  rules to your own wrapper class (`.x-tx b`, not `.x-r span`) whenever the container also holds
  `.num`, `.mark`, `.pill`, `.ln`, `.arw` or `.node`.

## Flex and inline text

- **A flex parent may hold exactly one plain-text child.** An element with `display:flex` whose
  *direct* children run **text first, then an element** (`Reviews it <b>selectively</b>`) splits the
  sentence into separate flex items with the container's gap between them. It survives on one line
  and breaks apart the moment anything wraps. Each `<br>` also becomes an empty flex item. Wrap the
  sentence in one child. **Icon-then-label** (`<span class="mark">` then text) is the intended idiom
  and is fine.
- **The sweep needs a parser, not a regex.** A non-greedy `(.*?)</div>` produces mostly false
  positives. Walk the DOM and flag only elements whose direct children run text, then element.
- **A `<span>` that is a flex/grid item gets blockified, but its children do not.**
  `<span><span class="k">A</span><span class="v">B</span></span>` inside a grid cell renders "A B" on
  one line. Give both children `display:block`.
- **An `<i>` that carries text renders italic**, and with no italic face imported the browser
  synthesises an oblique. Use `<span>`, or set `font-style:normal`. Grep for `<i` followed by a
  non-`>` character.

## SVG, connectors and geometry

- **Arrows point at the centre and stop on the edge.** Give every destination row a fixed height,
  size the SVG to the column's real height (`rows × height + gaps × gap`), and compute where the line
  meets the destination's edge. Ending at the true centre buries the arrowhead under the label.
- **If an `<svg>` is painted at a different size than its `viewBox`, every HTML overlay is
  misplaced.** Multiply overlay positions by the paint ratio, and write the ratio in a comment.
- **In a plan view the `<svg>` must come AFTER the zone divs.** `.svg-layer` has no z-index, so with
  the svg first the zones paint over the route.
- **A route goes round the furniture, not through it.** Run it along the aisle and turn into the
  destination's edge.
- **A shadow starts at the obstacle, not at the observer.** Shade only what lies beyond the
  obstacle's silhouette, bounded by the two rays through its outermost corners.
- **A rotated square (decision gate) paints its bounding box over its own vertex**, hiding an
  arrowhead that ends there. Leave ~24px clearance, or on a tight 16:9 fork make the connector into
  the gate deliberately headless and say so in a comment.
- **To show "many → few", draw ONE funnel wedge**, not N converging lines.
- **A to-scale rail collides at its crowded end.** Compute the smallest real interval first, size
  the cards to it, then derive the scale. Never nudge a mark inward to make it fit: that silently
  changes the data.
- **Verify custom SVG icons render as the thing you meant.** A hand-built "handoff" path can read as
  a "Zz" glyph. Prefer plain, unmistakable shapes (`M3 12h18M14 5l7 7-7 7`).
- **Never put an unlabelled abstract shape in a step position whose siblings carry text.** A row of
  worded cards reads as a sentence, so a cell of shapes reads as a gap. Say it in words and let a
  dashed border mark the weak end.

## Colour on the canvas

- **Never fill a shape with `var(--canvas)` on a `--canvas` stage.** It paints and is invisible.
  Use `--surface` for anything that must read as an object.
- **`--line` is not a bar colour on the bare stage.** It reads as an unfilled track. Use `--muted`
  for "present but not the subject". On a `--surface` card, `--line` is fine.
- **Never end a colour ramp within a hair of `--canvas`.** The quiet end of a stacked bar silently
  disappears. Stop at the lightest token that still reads as a fill.
- **An outline-only "empty" state disappears at blog width.** Empty cells need a real fill
  (`--brand-soft` works on both canvases).
- **On a dark canvas a fading ramp must fade toward OUTLINED, not darker.** A plate darker than the
  canvas reads as missing. Give the quiet end a `2px solid` border instead.

## Charts and numbers

- **Proportional means proportional.** A bar at 92% is 92% of its track. Put the scale in an HTML comment.
- **A value label above a bar needs headroom.** Scale the tallest bar to about **88%** of the plot
  and every other bar by the same factor; note the factor in a comment.
- **Two values within a couple of percent must not be drawn as bars.** Honest scale renders
  identical blocks that read as a rendering fault; a truncated axis misstates the finding. Use the
  figures stated in words, or a counted group where a small gap reads as small.
- **When near-equality IS the finding, state it, don't plot it.** Put the numbers on the image and
  say "near-even" in words.
- **A figure given only as a range cannot be drawn to scale.** Don't invent the missing axis; draw
  a ranking or a stated comparison, and say on the credit line that it is not to scale.

## Copy and sourcing

- **Draw only what the prose asserts.** A number that appears only in a cited URL's slug is not a
  number the article states.
- **Check that every claim printed on the image is true of the image.** "Same words, same length"
  on two panels that differ is false. Read every superlative and "identical" against the panels.
- **Never silently correct the article.** Draw the checkable version and flag the discrepancy at the
  top of PLACEMENT.md for whoever owns the copy.
- **Unsourced figures:** label them as a target or claim, not a result, and say so on `.credit` and
  at the top of PLACEMENT.md.
- **If a style rule bans vendor names, you can't draw a competitor's published research either.**
  Naming the source breaks the ban; using the figure unsourced breaks the evidence rule. Draw the
  idea, not the number, and say why on the credit line.
- **Grep against your own price list too.** An illustrative `$75` next to your domain is unfortunate
  if $75 is a real pricing tier.
- **Drafts change under you.** Re-read the source and re-run the adjacency check as the LAST step:
  flatten the text (strip `[text](url)` to its text, drop `**`, collapse whitespace), then test that
  `after + " " + before` is a substring. A quote that "looks identical" and fails is almost always a
  real edit, not an encoding problem.
- **"Draft" and "live" are claims to verify, not folder names.** Confirm status with a direct
  request to the real URL. A brand-new post can 404 for a while after it goes live.

## Tooling

- **`render.ps1` skips on the PNG's existence, not its timestamp.** Every re-render after an edit
  needs `-Force`, or the montage you review shows the previous version.
- **A montage window must be tall enough for every row**, or the last row is cropped with no error.
  `review.ps1` computes it; recompute by hand if you re-render `_gallery.html` after adding templates.
- **Never round-trip HTML through PowerShell 5.1 `Get-Content -Raw` → `Set-Content`.** It reads
  UTF-8-without-BOM as cp1252 and corrupts `→ · — ✓`. Use an editor, or
  `[IO.File]::ReadAllText($p,[Text.Encoding]::UTF8)` + `WriteAllText(..., (New-Object Text.UTF8Encoding $false))`.
- **Write `.ps1` files in pure ASCII.** One em dash in a comment makes PowerShell 5.1 fail to
  *parse* the whole file, with errors pointing at unrelated lines.
- PowerShell `-replace` takes exactly two arguments: `'a','b' + "x"` is a parse error.
- **Never pass text containing backticks through `python -c "..."` in Bash**, or through an
  unquoted heredoc (`<<EOF`). Bash substitutes them first and the file lands with silent holes. Use
  a file, a quoted heredoc (`<<'EOF'`), or an editor.
- **On Windows, `git ls-files` is case-sensitive while the filesystem is not.** A capitalised path
  reads fine from disk and returns nothing from git. Check with `git ls-files | grep -i <name>`.

---

## Pre-delivery checklist

- [ ] Every image in a different H2, each in a legal slot (PLACEMENT-RULES.md)
- [ ] Rendered with `-Force` after the last edit
- [ ] Montage read; bottom corners clear of `.site` / `.credit`; no overlapping titles
- [ ] Class-collision audit run
- [ ] No `<i>` with text; no text-then-element inside a flex container
- [ ] Every number traceable to the article and credited; bars proportional (scale in a comment)
- [ ] Every string grepped against `<Brand>/STYLE-RULES.md`, including your prices
- [ ] `.site` domain correct on every image
- [ ] Source re-read last; every PLACEMENT.md quote pair still adjacent
- [ ] Ledger updated
