## Writing style constraints


### Punctuation
- Never use em dashes (—) or en dashes (–) in prose. Use a comma, colon, semicolon, brackets, or split into two sentences.
- No emojis anywhere: prose, headings, bullets, commit messages, code comments.
- No decorative unicode: ✓ ✗ → ★ ▪ etc. Use plain markdown lists.
- Straight quotes and apostrophes only, not curly.
- No arrows (→) in prose. Write "leads to" or "then".

### Icons: use Elastic UI, never emojis
Where an icon genuinely aids scanning, use the Elastic UI (EUI) icon set. Never substitute an emoji.

- In React/EUI contexts, render `<EuiIcon type="check" />`. Pick the type from the official EUI icon list, do not invent icon names.
- In HTML/CSS contexts, use the EUI icon SVG or the EUI web font, not a unicode glyph.
- In plain markdown, Slack, or plaintext where EUI cannot render, use no icon at all. Use a word.
- Common mappings when an icon is warranted: success → `check`, failure → `cross`, warning → `warning`, information → `iInCircle`, error → `alert`, added → `plusInCircle`, removed → `minusInCircle`, docs → `documentation`, external link → `popout`.
- Colour icons via EUI tokens, not hardcoded hex.
- If unsure an icon is needed, omit it. Text-only is the default.

### Favicons on web UIs
Every web UI must ship a favicon. Never leave the browser default or a broken icon.

- Set the favicon in the HTML `<head>` on every page or in the shared layout/template, not per-page ad hoc.
- Prefer a project-specific or product-specific icon where one exists in the repo or brand assets.
- Where no suitable icon exists, default to the Elastic cluster logo mark.
- Serve as SVG with an ICO or PNG fallback for older browsers.
- Include the standard set: `icon` (SVG), `icon` (32x32 PNG), `apple-touch-icon` (180x180 PNG), and a `manifest` entry where the app is installable.
- Store assets under a predictable static path (for example `/static/icons/`) and reference them with absolute paths so they resolve from any route.
- Do not hotlink favicons from external CDNs. Vendor the asset into the repo.
- Provide a dark-mode variant via `media="(prefers-color-scheme: dark)"` where the mark would otherwise disappear against the tab background.
- Verify the favicon actually renders before declaring the UI done. A 404 on the icon is a bug, not cosmetic.

Reference markup:

```html
<link rel="icon" href="/static/icons/favicon.svg" type="image/svg+xml">
<link rel="icon" href="/static/icons/favicon-32.png" sizes="32x32" type="image/png">
<link rel="apple-touch-icon" href="/static/icons/apple-touch-icon.png" sizes="180x180">
<link rel="manifest" href="/static/site.webmanifest">
```

### Banned phrases and constructions
- No "It's not just X, it's Y" or "not only X but Y" antithesis constructions.
- No "delve", "tapestry", "landscape", "realm", "testament to", "underscores", "highlights the importance of", "navigate the complexities", "in today's fast-paced world", "at its core", "unlock", "harness", "leverage" (as a verb), "robust" as filler, "seamless", "game-changer", "deep dive", "elevate", "empower", "crucial", "pivotal", "vital", "ensure" as filler.
- No "I hope this helps", "Great question", "Certainly", "Let's dive in", "Buckle up".
- No "Here's the thing:" or "The reality is:".
- No rhetorical question openers.
- No "Whether you're X or Y" audience-hedging.
- No triads for rhythm ("faster, cleaner, simpler") unless all three are load-bearing.

### Structure
- No summary paragraph restating what was just said.
- No "In conclusion" / "To summarise" unless the document is long enough to warrant it.
- Don't bold random phrases mid-sentence for emphasis.
- Don't open every section with a one-line thesis statement.
- Vary sentence length. Avoid uniform medium-length sentences.
- No section headers on short documents.
- Don't hedge with "may", "might", "could potentially" when the answer is known.

### Self-check before output
Scan the draft for: em dashes, emojis, unicode glyphs standing in for icons, banned phrases, "not just X but Y", closing summary, missing favicon on any web UI. Remove or fix them.
