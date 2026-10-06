# Template library

39 reusable diagram skeletons in `_templates/`. Each is a real, renderable HTML file with neutral
placeholder copy. **Never edit a template in place for an article** — copy it into the article
folder, rename it, swap the brand stylesheet, and rewrite every string with the article's real facts.

Preview them all at once: `_templates/_gallery.png`.

## How to use one

1. Pick the template whose **question** matches what the paragraph is arguing (table below).
2. Copy `_templates/TNN-name.html` → `<Brand>/<article-slug>/NN-<scene>.html`.
3. Swap the first stylesheet link to your brand:
   `../brand.css` instead of `../_system/brand-neutral.css`
   (the second link becomes `../../_system/base.css` — one level deeper).
4. Replace every placeholder string. Replace the `.site` text (`clientdomain.com`) with your domain.
5. Render: `_system/render.ps1 -Path "<Brand>/<article-slug>" -Force`.
6. Log the pairing in `<Brand>/USED-TEMPLATES.md` so the next article doesn't repeat it.

## Ratio is a property of the idea, not the article

**Two ratios only.** No portrait (9:16) images — rebuild any you inherit as 16:9 or 1:1.

| Ratio | Body class | Canvas | Use for |
|---|---|---|---|
| 16:9 | `r169` | 1200×675 → 2400×1350 | sequences, comparisons, side-by-side, anything read left-to-right |
| 1:1 | `r11` | 1000×1000 → 2000×2000 | loops, radial structures, one big object, one number, vertical stacks and ladders |

## The 39

### Flow and process

| # | Template | Ratio | The question it answers |
|---|---|---|---|
| T01 | `flow-linear` | 16:9 | What goes in, what changes it, what comes out? |
| T02 | `flow-branch` | 16:9 | One source, several destinations (or reverse the arrows: several into one) |
| T03 | `cycle-loop` | 1:1 | Why does this keep coming back around? |
| T04 | `pipeline-vertical` | 1:1 | What are the ordered stages, and which one is the bottleneck? |
| T05 | `before-after` | 16:9 | What does the fix actually change? |
| T06 | `swimlane` | 16:9 | Who owns each part, and where does it change hands? |
| T07 | `funnel-drop` | 1:1 | Where is the volume leaking? |
| T08 | `fork-decision` | 16:9 | What happens when it passes the check, and when it doesn't? |

### Comparison

| # | Template | Ratio | The question it answers |
|---|---|---|---|
| T09 | `two-panel` | 16:9 | What is the relationship between these two things? |
| T10 | `vs-checklist` | 16:9 | Which option wins on which criterion? |
| T11 | `quadrant` | 1:1 | Given two trade-offs, where does each option land? |
| T12 | `tier-ladder` | 1:1 | What level am I on, and what does the next one look like? |

### Anatomy

| # | Template | Ratio | The question it answers |
|---|---|---|---|
| T13 | `anatomy-callouts` | 1:1 | What is this one thing made of? |
| T14 | `annotated-screen` | 16:9 | Where on the screen does this happen, and why does it matter? |
| T15 | `sentence-dissect` | 16:9 | What is each part of this sentence/rule doing? |
| T16 | `exploded-stack` | 1:1 | What layers is this system built from? |

### Numbers

| # | Template | Ratio | The question it answers |
|---|---|---|---|
| T17 | `stat-tiles` | 16:9 | What are the three numbers worth quoting? |
| T18 | `bar-ranking` | 1:1 | Which of these is biggest, and by how much? |
| T19 | `gauge-target` | 1:1 | Where are we against the bar we have to clear? |
| T20 | `timeline` | 16:9 | What happens when? |
| T21 | `cost-escalation` | 16:9 | Why is catching it early worth so much? |
| T22 | `column-compare` | 16:9 | How do two approaches score across the same categories? |

### Concept

| # | Template | Ratio | The question it answers |
|---|---|---|---|
| T23 | `hub-spoke` | 1:1 | What does everything else depend on? |
| T24 | `venn-overlap` | 1:1 | Where do these two ideas genuinely overlap? |
| T25 | `layer-cake` | 1:1 | What has to be true before the next thing can work? |
| T26 | `icon-grid` | 1:1 | What is the full set, with no order implied? |
| T27 | `numbered-steps` | 16:9 | What is the named 4-step method? |
| T28 | `do-dont` | 16:9 | What should I stop doing, and what replaces it? |
| T29 | `span-bracket` | 16:9 | This term sounds like the whole thing — which part does it actually cover? |
| T30 | `unit-grid-gap` | 16:9 | What does that percentage look like as countable things? |
| T31 | `target-band` | 16:9 | Both ways of getting it wrong cost something — how narrow is "right"? |
| T32 | `sawtooth-replenishment` | 16:9 | What does this level do between top-ups? |
| T33 | `coverage-matrix` | 16:9 | Why more than one of each, and what does the redundancy buy? |
| T34 | `converge-diverge` | 16:9 | Why is this one thing load-bearing? |
| T35 | `stacked-share` | 16:9 | Once the big shares are taken out, how little is left? |
| T36 | `scorecard-rows` | 1:1 | Where does ONE thing stand on each of several identical scales? |
| T37 | `spread-vs-average` | 16:9 | The number everyone quotes — does it describe any of the cases? |
| T38 | `plan-view` | 16:9 | Where is it in the room, and what does moving it change? |
| T39 | `rank-inversion` | 16:9 | The published order and the measure disagree &mdash; where do they cross? |

## House style (applies to every template)

- **Three type sizes per image, maximum.** Use `var(--fs-xl)` / `var(--fs-md)` / `var(--fs-sm)` and
  reuse them for everything, including `.site` and `.credit`. Hierarchy comes from **weight and
  colour**, never from inventing a fourth size. Same ceiling on text colours: `--ink`, `--muted`,
  and accents only where they encode meaning (good vs bad, this-one-not-that-one) — never for
  decoration. An image with a headline should NOT also have a bigger number; pick one display
  element.
- **Rows across sibling cards must line up.** Give shared headers a fixed height so a title that
  wraps on one side doesn't push that card's rows out of alignment with its twin.
- **Every cell in a labelled sequence has to be labelled.** A row of worded cards reads as a
  sentence, so a step drawn as bare shapes reads as an empty cell, not as "a mess of things". Say it
  in words; use a dashed border or a muted fill to mark it as the weak end of the comparison.
  Abstract shapes are still right when the whole block is one labelled group and counting them is
  the point — field grids, unit grids, scorecard cells.
- **One idea per image.** If it needs a second sentence of explanation, it is two images.
- **Readable in ~2 seconds** at blog width. 2–6 objects. Big type, huge whitespace.
- **Flat.** Shadows are a whisper (`--lift`) and only on cards. No gradients except `--grad-brand`
  on a single hero element per image. No drop-shadowed text, no 3-D, no clip art.
- **Brand tokens only.** Never a hex value that isn't in your `brand.css`.
- **Arrows point at the CENTRE of what they hit.** When a connector SVG feeds a column of shapes,
  give every destination row a fixed height, size the SVG to the column's real height
  (`rows × height + gaps`), and read each endpoint off that. If the two disagree, the SVG is centred
  against the column and every arrow silently drifts off its target.
- **Card and bubble content is vertically centred**, and never laid out so it wraps unevenly.
- **Attribution goes in `.credit`** (bottom-left, mirrors `.site`). Never hand-roll `left:0` — an
  absolutely-positioned child is placed against the stage's padding box and ends up jammed against
  the canvas edge.
- **Never put text on or above a connector line.** Bare text floating over an arrow or a curve is
  hard to read on the flat canvas. If a connector needs a name, either put it in a **solid pill**
  clear of the line (T09), or move it onto the **thing it points at** as a small pill above that
  item's heading (T08).
- **Your domain, bottom-right, every single image** (`.site`). No exceptions.
- **Real numbers or none.** If a figure appears, it must come from the article and its source must be
  named on the image. Invented statistics are the fastest way to burn a brand's credibility.
- **Proportional means proportional.** A bar at 92% must be 92% of its track. Put the scale in an
  HTML comment so the next person can check it.
- **Competitors stay generic** unless the article names them and treats them fairly.

### T36 scorecard-rows, in more detail

It answers a question no other template does: **one subject, many identical small-integer scales, and a total**. Reach for it whenever an
article hands the reader a worksheet to fill in - readiness scores, maturity rubrics, audit sheets,
self-assessments.

Its neighbours answer different questions, so check before you pick it: **T18 bar-ranking** asks
which of several things is biggest; **T22 column-compare** scores *two* options across categories;
**T19 gauge-target** puts one measure against a threshold.

Three things it has to get right:

- **The filled cells must equal the stated score**, and rows x scale must equal the total. A reader
  counts them, which is most of the point.
- **No headline.** The total is the one display element, so the row labels carry the context.
- **Empty cells need a visible fill, not an outline.** An outline-only cell disappears at blog width
  and the scale stops being countable.

### T37 spread-vs-average, in more detail

It answers a question no other template does: **is the summary statistic you are quoting true of anybody?** Reach for it whenever an
article tells the reader to look at the spread rather than the mean - cycle times, delivery windows,
response times, order-to-confirmation, anything with a long tail and a comforting average.

Its neighbours answer different questions: **T18 bar-ranking** asks which of several things is
biggest; **T19 gauge-target** puts one measure against a threshold; **T31 target-band** asks how
narrow "right" is. None of them can show that a mean falls in an almost-empty bucket.

Three things it has to get right:

- **The counts must add to the stated sample**, and the bar heights must be those counts against the
  tallest bar. A reader checks, which is most of the point.
- **Tag the two statistics onto the bars they fall on**, never onto the axis - a label floating over
  a chart is the same mistake as a label on a connector line.
- **Say where the distribution came from.** If the shape is constructed to be consistent with a
  median and an average the article states, rather than measured, the `.credit` line has to say so.

### T38 plan-view, in more detail

It answers a question no other template can: **where is this in
the room?** Reach for it whenever the argument is spatial — a route that crosses a zone, a
sightline an object blocks, a zone sitting in the wrong corner, a fixed point everything else has to
work around. Its neighbour is **T05 before-after**, which answers "what does the fix change?" as a
list of symptoms and cannot show where anything is.

This is the only template in the library that draws a *place* rather than a structure.

Four things it has to get right, all learned the hard way:

- **Change exactly one thing between the two plans.** Keep the room, the door, the fixed points and
  any route identical, so the difference is attributable to the single move and nothing else. Two
  plans that differ in three ways prove nothing.
- **The `<svg>` goes AFTER the zone divs.** base.css's `.svg-layer` carries no z-index, so with the
  svg first every zone box paints over the route — a line then reads as stopping dead at the obstacle
  instead of crossing it, and an arrowhead that lands inside a destination box vanishes completely.
- **Zone labels go in a corner the geometry never reaches**, bottom-right by default. Centred, a
  label sits directly under whatever crosses its box, which is the same legibility problem the
  no-text-on-connector-lines rule exists to prevent.
- **A connector stops on the destination's EDGE, collinear with its centre.** The house rule is that
  arrows land on centres, but ending dead centre buries the arrowhead under that zone's own label.
  Compute where the line meets the box and stop there.

**A route has to go ROUND the furniture, not through it.** A straight line from the door to its
destination is the obvious way to draw a walk, and it will happily cross an intervening rack -
asserting a path straight through shelving. Because the svg paints over the zone
divs it looked deliberate rather than broken. Run the connector along the aisle and turn into the
destination's edge. The two plans then share one route *shape* and differ only in length, which is
the comparison the template exists to make.

**If the plan shows a shadow** — what an observer cannot see past an obstacle — remember the ground
*between* the observer and the obstacle is visible. Shade only what lies beyond the obstacle's
silhouette, bounded by the two rays from the observer through its outermost corners. A wedge drawn
straight from the observer looks convincing and shades ground the observer can actually see.


### T39 rank-inversion, in more detail

**The question it answers:** a source ranks things by one thing and reports another, and the two
orders disagree. "Frequency is not risk." "It appears in more applications and ranks three places
lower." "The biggest is not the most common."

**Why it is not a bar chart, and this is the whole point.** The instinct is to plot the measure and
let the reader see the order. That fails exactly when this template is needed, because the pairs
that invert are almost always *close* on the measure - and two values within a couple of percent
render as identical blocks and read as a rendering fault. The **positions** carry the comparison; the measure sits on each card as a label.

**Only order what the source measures.** If some items publish no value, leave them out of the
second column and say so on the credit line. An inversion drawn over invented ranks is worse than
no image. If only four of ten categories publish a share, only those four are ordered.

**Geometry.** Fixed row height, so the connector endpoints land on row centres. The svg is sized to
the real column height (rows x height + gaps x gap) and placed in the middle grid track **after**
the columns in source order, so it paints over them rather than under. Connectors carry no text -
every label sits on an endpoint card.

## Adding a template

The library is meant to grow — whenever an article needs a shape that isn't here, build it as
`T<next>-<name>.html` with neutral copy, add a row above, and re-render `_gallery.png`. Only add a
template if it answers a **question none of the existing ones already answers** — a
variation in styling is not a new template.

## Gotchas already paid for

- `flex-direction:row-reverse` **inverts** `justify-content`: `flex-start` packs to the right. This
  silently mirrored the left-hand callouts in T13.
- `transform:rotate(-90deg)` spins about the element centre, so a rotated axis label's visual x is
  `left + width/2`, not `left` (T11 overlapped the grid).
- A `<span>` used as a bar fill needs `display:block`, or its `width` is ignored.
- Don't name a per-file class after a base.css class (`.row`, `.node`, `.tile`, `.bar-fill`, `.site`,
  `.lab`) — it inherits the base styles and the bug looks like a rendering fault. Prefix instead.
