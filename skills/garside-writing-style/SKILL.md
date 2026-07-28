---
name: garside-writing-style
description: how to analyze, critique, and correct written text like James Garside, looking for obvious signs of AI generation. 
---

Audit this repository against the "Writing style constraints" listed in constraints.md. Do not fix anything yet. Produce a report first.

Scope: all tracked files. Include markdown, code comments, docstrings, commit messages on the current branch, README, docs/, HTML templates, JSX/TSX, and string literals rendered to users. Exclude vendored dependencies, lockfiles, node_modules, and generated build output.

Check for, and report every occurrence with file path and line number:

1. Em dashes and en dashes in prose or user-facing strings. Ignore them inside code where they are legitimate data.
2. Emojis, in any file type, including commit messages and code comments.
3. Decorative unicode glyphs used as icons or bullets.
4. Curly quotes and apostrophes in source, where straight ones belong.
5. Unicode arrows in prose.
6. Emojis or unicode glyphs used where an EUI icon should be. For each, propose the EUI icon type.
7. EUI icon names that do not exist in the pinned EUI version. Flag as broken.
8. Hardcoded hex colours on icons where an EUI token exists.
9. Any web UI entry point without a favicon link in the head, or with a favicon that 404s, or hotlinked from an external CDN. Check every layout, template, and index.html.
10. Missing apple-touch-icon, 32x32 PNG fallback, or manifest entry.
11. Banned phrases from the list.
12. "Not just X but Y" and "not only X but Y" constructions.
13. Redundant closing summary paragraphs in docs.
14. UK spellings where US English is required.

Output a table: file, line, category, the offending text, the proposed replacement.
Then output a summary count by category.
Then rank the findings: things that break rendering or 404 first, then user-facing prose, then internal comments.

Do not paraphrase or rewrite anything beyond what the rules require. Do not touch logic. Do not reformat unrelated lines.

Once I approve, apply the fixes in separate commits grouped by category so they can be reviewed and reverted independently. 
