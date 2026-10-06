# Placement rules

Every article folder ships a `PLACEMENT.md` telling the editor exactly where each image goes.
The rules below are hard constraints — a placement that breaks one is wrong even if it "looks fine".

## The five hard rules

1. **Never adjacent to a table or a list.** At least one full sentence of body copy must sit between
   the image and any table, bulleted list, or numbered list — on *both* sides.
2. **Never directly under a heading.** At least one paragraph of body copy must come first, so the
   reader knows what the section is about before the picture arrives.
3. **Never at the end of a section.** At least one paragraph must follow the image inside the same
   section, so the image is something the text moves *through*, not a full stop.
4. **Never adjacent to a CTA.** A full paragraph must separate the image from any CTA block, button,
   or "contact us" line, in either direction.
5. **One image per section, maximum.** Two images in one H2 makes the section feel like a slideshow.

Together these mean the only legal slot is: **between two body paragraphs, inside a section that has
body copy above and below, away from tables, lists and CTAs.**

## The transition sentence

Each image gets one short sentence placed immediately above it, in the article's voice, that hands
the reader off to the picture. It should:

- be **one sentence**, under ~20 words;
- **say what the image shows**, not "see the image below";
- read naturally if the image were removed;
- never repeat the preceding sentence's wording.

Good: *The five stages are easier to hold in your head laid out end to end.*
Bad: *The diagram below illustrates the five stages of the order management workflow.*

## PLACEMENT.md format

One block per image, in article order:

```markdown
### 01 — <scene-name> · <ratio> · `<file>.png`

**Section:** H2 "<exact heading text>"

**Goes after this sentence:**
> <exact sentence copied verbatim from the published article>

**Goes before this sentence:**
> <exact sentence copied verbatim from the published article>

**Transition sentence to insert above the image:**
> <the one-sentence handoff>

**Alt text:** <literal description of the image, ~12 words, includes the topic keyword once>
**Caption (optional):** <one line, only if it adds a fact the image can't show>

**Rule check:** heading ✓ · table/list ✓ · section end ✓ · CTA ✓
```

The before/after sentences must be **copied from the live published page**, not from the draft —
editors search for that exact string, so a paraphrase costs them the placement. If the draft and the
live page differ, the live page wins. Strip links to their text and drop `**` markup: editors search
the rendered text.

**Article not live yet?** Take the quotes from the draft, put a banner at the top of `PLACEMENT.md`
saying so (with the time you read it), and re-verify every search string and the adjacency of each
pair once the page is published. Drafts change while you build: re-read the source as the last step.

**A 404 on a brand-new post often means "not propagated yet", not "not published".** New pages can
404 and be missing from `sitemap.xml` for a while after going live. Re-check before building from the
draft.

## Which articles we build for

**Non-listicle articles only.** "Best/Top N … software" round-ups are out of scope — they already
carry their own imagery. Guides, how-tos and explainers are in scope. Filter the listicles out
before you pick a batch.

## When an article can't host five images

Some articles are written as paragraph → list → paragraph the whole way down. Those have almost no
legal slots, and forcing five images means breaking the rules above.

**Deliver what fits and say why.** List every skipped section at the bottom of `PLACEMENT.md` with
the reason ("paragraph, bulleted list, paragraph — no legal slot"). An honest four is worth more
than a fifth image jammed against a table.

## "N ideas" articles: a numbered run is not a list

Some articles - "60 Event Ideas", "50 Ways to …" - are built as *opening paragraph -> a run of bold-led numbered idea paragraphs ->
closing paragraph*, section after section. Whether those numbered items count as a **list** under
rule 1 decides whether the article has five legal slots or two.

**They are paragraphs.** Each is two to four sentences of real prose and each renders as its own
`<p>`. Counting them as lists would leave these articles with almost no legal slots at all.

So: an image **may** sit beside a numbered run, and the right slot is **after the section's opening
paragraph and before its first numbered item**, where it argues the point that paragraph has just
made. An image must **never** sit *between* two numbered items - that breaks the enumeration and
makes the picture look like it belongs to item N.

**Say so at the top of the `PLACEMENT.md`.** It is a judgement call, it changes how many images the
article can host, and the editor should be able to overrule it.

## When the article's figures have no source

Some articles state benchmarks with no attribution. Do not invent one, and do not present the number
as if it were measured.

- Put the figure on the image, but label it as a **target** or a **claim**, not a result.
- Use the `.credit` line to say plainly where it came from — e.g. "Figure as stated in this guide;
  no source is given for it."
- Repeat the warning at the top of `PLACEMENT.md` so an editor doesn't add a source in a caption.

## Choosing the five slots

- Spread them across the article — one near the top, one near the end, three through the middle.
  Never cluster two in adjacent sections if a later section is left bare.
- Match the template to what the paragraph is **arguing**, not to what it is *about*. A section that
  argues "catching it early is cheaper" wants T21 (cost-escalation), not a picture of the stages.
- Sections that already carry a table are usually the *worst* place for an image: the reader has just
  been given a dense block. Prefer the section after it.
- The FAQ block never gets an image.

## Delivery

For each article, hand over:

- `NN-<scene>.png` × 5 (rendered at 2×)
- `NN-<scene>.html` × 5 (the editable source)
- `PLACEMENT.md`
