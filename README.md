# derickson/claude-skills

Personal skill library for Claude Code (and compatible agents). Install into any project or machine with [`npx skills`](https://github.com/vercel-labs/skills).

## Install

```bash
# Into the current project (.claude/skills/)
npx skills add derickson/claude-skills


## common external library skills I like to install globally
npm install -g @playwright/cli@latest
npx skills add microsoft/playwright-cli -g -y



## common external library skills I like to install (per project , for global add -g)
npx skills add Forward-Future/loopy --skill loopy --agent claude-code -y

# Update all skills
npx skills update
```

After installation, skills are invoked by name in your coding agent:

```
/humanizer do a thing
/hermes-dispatch what's on the board
/python-http-server serve this directory
```

## Commands

Commands go into `.claude/commands/` and are invoked as `/command-name`. `npx skills` doesn't install commands automatically — copy them manually:

```bash
# Into the current project
cp -r "$(npx skills path derickson/claude-skills 2>/dev/null || echo ~/.agents/skills/derickson-claude-skills)/../commands" .claude/

# Or directly from a clone of this repo
cp path/to/claude-skills/commands/*.md .claude/commands/
```

| Command | Description |
|---|---|
| `git-auto-commit` | Add and commit all changes with a descriptive message |
| `git-issuebranch-cleanup` | Delete remote branches for merged/closed PRs |
| `uv-venv-init` | Create a Python venv in `~/.venvs/<project>` with a local symlink |

## Skills

| Skill | Description | Source |
|---|---|---|
| `build-with-agent-team` | Orchestrate multi-agent teams using Claude Code Agent Teams with tmux split panes | authored |
| `cmux` | End-user control of cmux topology and routing (windows, workspaces, panes/surfaces) | sourced |
| `cmux-browser` | Browser automation inside cmux webviews | sourced |
| `dave-project-tips` | Conventions for projects on Dave's server (FastAPI, Vite, Docker, nginx, Elasticsearch) | authored |
| `hermes-dispatch` | Queue, monitor, and report on tasks on the remote Hermes agent kanban board over SSH | authored |
| `humanizer` | Remove AI writing patterns to make text sound more natural and human-written | sourced (MIT) |
| `nanobanana-generate` | Generate images using Google's nano-banana-2 model on Replicate API | authored |
| `python-http-server` | Start, list, and stop Python simple HTTP servers | authored |

**Source key:** `authored` = written by me; `sourced` = imported from elsewhere, original license preserved in the skill directory.

## Adding a new skill

1. Create `skills/<skill-name>/SKILL.md` following the [Claude Code skill format](https://docs.anthropic.com/en/docs/claude-code/skills)
2. If sourced from elsewhere, preserve the original `LICENSE` file and note provenance in the skill's `README.md`
3. Update the table above
4. Commit and push — anyone can re-install with `npx skills update`

## Structure

```
commands/
  <name>.md           ← slash command; copied to .claude/commands/
skills/
  <name>/
    SKILL.md          ← required; loaded by the agent
    LICENSE           ← include if sourced with a license
    README.md         ← optional; human-readable docs
    scripts/          ← optional; supporting scripts
    references/       ← optional; supporting reference docs
```
